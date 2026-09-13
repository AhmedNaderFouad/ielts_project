import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/confirm_reset_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final SendOTPUseCase sendOTPUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;
  final ConfirmResetUseCase confirmResetUseCase;
  final AuthRepository authRepository;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.resetPasswordUseCase,
    required this.sendOTPUseCase,
    required this.verifyOTPUseCase,
    required this.confirmResetUseCase,
    required this.authRepository,
  }) : super(AuthInitial());

  // Temporary storage for flows
  String? _tempName;
  String? _tempEmail;
  String? _tempPassword;
  String? _tempUserId; // Track userId for verification

  // Track last sent emails for flows
  String? _lastSentEmail;
  String? _lastSignUpEmail;
  String? get lastSentEmail => _lastSentEmail;
  String? get lastSignUpEmail => _lastSignUpEmail;

  // Resend Timer Logic
  int _resendCooldown = 0;
  Timer? _timer;

  int get resendCooldown => _resendCooldown;

  bool get isPreferencesCompleted => authRepository.getPreferencesCompleted();

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    // 1. If email is unchanged and timer is active, just navigate forward
    if (email == _lastSignUpEmail && _resendCooldown > 0) {
      emit(SignupOTPRequired(email: email, userId: _tempUserId));
      return;
    }

    emit(AuthLoading());

    // 2. Check if email exists first
    final emailCheck = await authRepository.checkEmailExists(email);
    bool exists = false;
    emailCheck.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (isRegistered) => exists = isRegistered,
    );
    if (state is AuthFailure) return;

    if (exists) {
      emit(
        const AuthFailure(
          "This email is already registered. Please sign in instead.",
        ),
      );
      return;
    }

    // 3. Create the user account first (unverified)
    final result = await signUpUseCase(
      SignUpParams(name: name, email: email, password: password),
    );

    await result.fold((failure) async => emit(AuthFailure(failure.message)), (
      user,
    ) async {
      _tempName = name;
      _tempEmail = email;
      _tempPassword = password;
      _tempUserId = user.id;

      // 4. Send OTP
      final otpResult = await sendOTPUseCase(email);
      otpResult.fold((failure) => emit(AuthFailure(failure.message)), (_) {
        _lastSignUpEmail = email;
        startResendTimer();
        emit(SignupOTPRequired(email: email, userId: user.id));
      });
    });
  }

  Future<void> verifySignupOTP(String code) async {
    if (_tempEmail == null || _tempUserId == null) return;
    emit(AuthLoading());

    final verifyResult = await verifyOTPUseCase(
      VerifyOTPParams(email: _tempEmail!, code: code, userId: _tempUserId),
    );

    verifyResult.fold((failure) => emit(AuthFailure(failure.message)), (token) {
      // Cleanup registration state
      _tempName = null;
      _tempEmail = null;
      _tempPassword = null;
      _tempUserId = null;
      _lastSignUpEmail = null;
      _resendCooldown = 0;
      _timer?.cancel();

      // Finalize state
      emit(EmailVerifiedState());
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    emit(AuthLoading());
    final result = await signInUseCase(
      SignInParams(email: email, password: password),
    );
    result.fold((failure) => emit(AuthFailure(failure.message)), (user) async {
      await authRepository.setRememberMe(rememberMe);
      emit(AuthAuthenticated(user));
    });
  }

  Future<void> signInWithGoogle({bool rememberMe = true}) async {
    emit(AuthLoading());
    final result = await authRepository.signInWithGoogle(
      rememberMe: rememberMe,
    );
    result.fold((failure) => emit(AuthFailure(failure.message)), (user) async {
      await authRepository.setRememberMe(rememberMe);
      emit(AuthAuthenticated(user));
    });
  }

  Future<void> sendResetOTP(String email) async {
    // 1. If email is unchanged and timer is active, just navigate forward
    if (email == _lastSentEmail && _resendCooldown > 0) {
      emit(OTPSentSuccess(email: email));
      return;
    }

    emit(AuthLoading());

    // 2. Check if email exists first
    final emailCheck = await authRepository.checkEmailExists(email);
    bool exists = false;
    emailCheck.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (isRegistered) => exists = isRegistered,
    );
    if (state is AuthFailure) return;

    if (!exists) {
      emit(
        const AuthFailure(
          "This email is not registered. Please check the address or create a new account.",
        ),
      );
      return;
    }

    // 3. Send OTP
    final result = await sendOTPUseCase(email);
    result.fold((failure) => emit(AuthFailure(failure.message)), (_) {
      _lastSentEmail = email;
      startResendTimer();
      emit(OTPSentSuccess(email: email));
    });
  }

  Future<void> verifyResetOTP(String email, String code) async {
    emit(AuthLoading());
    final result = await verifyOTPUseCase(
      VerifyOTPParams(email: email, code: code),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (token) => emit(OTPVerificationSuccess(token)),
    );
  }

  Future<void> confirmPasswordReset({
    required String email,
    required String newPassword,
    required String resetToken,
  }) async {
    emit(AuthLoading());
    final result = await confirmResetUseCase(
      ConfirmResetParams(
        email: email,
        newPassword: newPassword,
        resetToken: resetToken,
      ),
    );
    result.fold((failure) => emit(AuthFailure(failure.message)), (_) {
      _lastSentEmail = null; // Clear after successful reset
      emit(PasswordResetSuccess());
    });
  }

  void startResendTimer() {
    _resendCooldown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown > 0) {
        _resendCooldown--;
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> checkAuthStatus() async {
    final isRememberMe = authRepository.getRememberMe();
    final result = await authRepository.getCurrentUser();

    result.fold((_) => emit(AuthUnauthenticated()), (user) async {
      if (user != null && isRememberMe) {
        emit(AuthAuthenticated(user));
      } else {
        if (user != null) {
          await authRepository.signOut();
        }
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> logout() async {
    await authRepository.signOut();
    emit(AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
