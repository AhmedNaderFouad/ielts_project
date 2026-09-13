import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Authentication error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Authentication error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Error sending reset email'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendOTP({required String email}) async {
    try {
      await remoteDataSource.sendOTP(email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Error sending OTP'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOTP({
    required String email,
    required String code,
    String? userId,
  }) async {
    try {
      final resetToken = await remoteDataSource.verifyOTP(
        email: email,
        code: code,
        userId: userId,
      );
      return Right(resetToken);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Error verifying OTP'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmPasswordReset({
    required String email,
    required String newPassword,
    required String resetToken,
  }) async {
    try {
      await remoteDataSource.confirmPasswordReset(
        email: email,
        newPassword: newPassword,
        resetToken: resetToken,
      );
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Error resetting password'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle({
    bool rememberMe = true,
  }) async {
    try {
      final user = await remoteDataSource.signInWithGoogle(
        rememberMe: rememberMe,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Google Sign-In error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await localDataSource.setRememberMe(false);
      await remoteDataSource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailExists(String email) async {
    try {
      final exists = await remoteDataSource.checkEmailExists(email);
      return Right(exists);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> setRememberMe(bool value) async {
    await localDataSource.setRememberMe(value);
  }

  @override
  bool getRememberMe() {
    return localDataSource.getRememberMe();
  }

  @override
  Future<void> setPreferencesCompleted(bool value) async {
    await localDataSource.setPreferencesCompleted(value);
  }

  @override
  bool getPreferencesCompleted() {
    return localDataSource.getPreferencesCompleted();
  }
}
