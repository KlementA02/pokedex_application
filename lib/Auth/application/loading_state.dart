import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
part 'loading_state.freezed.dart';

@freezed
class LoadingState with _$LoadingState {
  const LoadingState._();
  const factory LoadingState({
    required bool isLoading,
  }) = _LoadingState;
}

class LoadingStateNotifier extends StateNotifier<LoadingState> {
  LoadingStateNotifier() : super(const LoadingState(isLoading: false));

  void startLoading() {
    state = state.copyWith(isLoading: true);
  }

  void stopLoading() {
    state = state.copyWith(isLoading: false);
  }
}
