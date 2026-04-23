import '../../data/datasources/theory_local_datasource.dart';

/// Use case: retrieves structured music theory lessons from local data.
class GetTheoryLessonUseCase {
  const GetTheoryLessonUseCase(this._datasource);

  final TheoryLocalDatasource _datasource;

  Future<List<Map<String, dynamic>>> execute() => _datasource.getLessons();
}
