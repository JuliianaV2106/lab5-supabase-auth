import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviles_auth/features/auth/domain/usecases/sign_out_usecase.dart';

abstract class HomeEvent {}

class SignOutRequested extends HomeEvent {}

enum HomeStatus { initial, loading, signedOut, failure }

class HomeState {
  final HomeStatus status;
  final String? errorMessage;

  const HomeState({this.status = HomeStatus.initial, this.errorMessage});

  HomeState copyWith({HomeStatus? status, String? errorMessage}) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SignOutUseCase _signOut;

  HomeBloc(this._signOut) : super(const HomeState()) {
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      await _signOut();
      emit(state.copyWith(status: HomeStatus.signedOut));
    } on Exception catch (e) {
      emit(
        state.copyWith(status: HomeStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
