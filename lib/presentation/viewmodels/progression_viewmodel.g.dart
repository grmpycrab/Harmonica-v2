part of 'progression_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$progressionViewModelHash() =>
    r'e21074ed201c11014507aec7a73e8fa5e2e45918';

/// See also [ProgressionViewModel].
@ProviderFor(ProgressionViewModel)
final progressionViewModelProvider = AutoDisposeNotifierProvider<
    ProgressionViewModel, ProgressionState>.internal(
  ProgressionViewModel.new,
  name: r'progressionViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$progressionViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProgressionViewModel = AutoDisposeNotifier<ProgressionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
