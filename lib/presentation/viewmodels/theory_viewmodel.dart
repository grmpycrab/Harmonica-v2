import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/app_providers.dart';

part 'theory_viewmodel.g.dart';

@riverpod
class TheoryViewModel extends _$TheoryViewModel {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final useCase = ref.read(getTheoryLessonUseCaseProvider);
    return useCase.execute();
  }
}
