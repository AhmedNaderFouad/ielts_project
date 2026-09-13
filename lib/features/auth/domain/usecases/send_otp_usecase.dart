import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SendOTPUseCase implements UseCase<Unit, String> {
  final AuthRepository repository;

  SendOTPUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String email) {
    return repository.sendOTP(email: email);
  }
}
