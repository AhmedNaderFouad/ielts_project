import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ConfirmResetUseCase implements UseCase<Unit, ConfirmResetParams> {
  final AuthRepository repository;

  ConfirmResetUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ConfirmResetParams params) {
    return repository.confirmPasswordReset(
      email: params.email,
      newPassword: params.newPassword,
      resetToken: params.resetToken,
    );
  }
}

class ConfirmResetParams {
  final String email;
  final String newPassword;
  final String resetToken;

  ConfirmResetParams({
    required this.email,
    required this.newPassword,
    required this.resetToken,
  });
}
