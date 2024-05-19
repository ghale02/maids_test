import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/core/usecases.dart';
import 'package:maids_test/features/todos/domain/entities/todos_list_entity.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';

class GetTodosUseCase extends UseCase<GetTodosParams, TodosListEntity> {
  final TodosRepositoryAbstract repository;

  GetTodosUseCase({required this.repository});

  @override
  Future<Either<Failure, TodosListEntity>> call(GetTodosParams params) async {
    return await repository.getTodos(params.skip);
  }
}

class GetTodosParams extends Equatable {
  final int skip;

  const GetTodosParams({required this.skip});

  @override
  List<Object> get props => [skip];
}
