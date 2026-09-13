import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyOTPUseCase implements UseCase<String, VerifyOTPParams> {
  final AuthRepository repository;

  VerifyOTPUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(VerifyOTPParams params) {
    return repository.verifyOTP(
      email: params.email,
      code: params.code,
      userId: params.userId,
    );
  }
}

class VerifyOTPParams {
  final String email;
  final String code;
  final String? userId;

  VerifyOTPParams({required this.email, required this.code, this.userId});
}
