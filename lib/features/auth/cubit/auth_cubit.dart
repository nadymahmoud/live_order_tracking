import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking_app/core/constant/data_saved.dart';
import 'package:order_tracking_app/features/auth/cubit/auth_state.dart';
import 'package:order_tracking_app/features/auth/repo/auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit( this._authRepo) : super(AuthInitial());
  final AuthRepo _authRepo;

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _authRepo.loginUser(email: email, password: password);
    result.fold((l) => emit(AuthError( l)), (userModel) {
      UserData.userModel = userModel;
      emit(AuthSuccess( "Login Success" ));
    });
  }
  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _authRepo.registerUser(username: username, email: email, password: password);
    result.fold((l) => emit(AuthError( l)), (message) => emit(AuthSuccess( message )));
  }
}
