import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<Unit, String> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String email) {
    return repository.sendPasswordResetEmail(email: email);
  }
}
