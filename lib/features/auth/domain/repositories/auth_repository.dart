import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> sendPasswordResetEmail({required String email});

  Future<Either<Failure, Unit>> sendOTP({required String email});

  Future<Either<Failure, String>> verifyOTP({
    required String email,
    required String code,
    String? userId,
  });

  Future<Either<Failure, Unit>> confirmPasswordReset({
    required String email,
    required String newPassword,
    required String resetToken,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle({
    bool rememberMe = true,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, bool>> checkEmailExists(String email);

  // Local Storage Methods
  Future<void> setRememberMe(bool value);
  bool getRememberMe();
  Future<void> setPreferencesCompleted(bool value);
  bool getPreferencesCompleted();
}
