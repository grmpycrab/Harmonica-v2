part of 'theory_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$theoryViewModelHash() => r'fea0e272985a450b5c43fd24db40f61ed8e0e232';

/// See also [TheoryViewModel].
@ProviderFor(TheoryViewModel)
final theoryViewModelProvider = AutoDisposeAsyncNotifierProvider<
    TheoryViewModel, List<Map<String, dynamic>>>.internal(
  TheoryViewModel.new,
  name: r'theoryViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$theoryViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TheoryViewModel
    = AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
