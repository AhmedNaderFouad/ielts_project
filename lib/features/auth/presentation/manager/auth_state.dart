import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;
  const AuthFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class OTPSentSuccess extends AuthState {
  final String email;
  final bool isForSignup;
  const OTPSentSuccess({required this.email, this.isForSignup = false});

  @override
  List<Object?> get props => [email, isForSignup];
}

class OTPVerificationSuccess extends AuthState {
  final String resetToken;
  const OTPVerificationSuccess(this.resetToken);

  @override
  List<Object?> get props => [resetToken];
}

class EmailVerifiedState extends AuthState {}

class PasswordResetSuccess extends AuthState {}

class SignupOTPRequired extends AuthState {
  final String email;
  final String? userId;
  const SignupOTPRequired({required this.email, this.userId});

  @override
  List<Object?> get props => [email, userId];
}
