import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
part 'login_form_state.freezed.dart';

@freezed
class LoginFormState with _$LoginFormState {
  const LoginFormState._();
  const factory LoginFormState({
    required String userName,
    required String password,
    required String server,
    String? userNameError,
    String? passwordError,
  }) = _LoginFormState;
}

class LoginFormStateNotifier extends StateNotifier<LoginFormState> {
  LoginFormStateNotifier()
      : super(const LoginFormState(
            userName: '', password: '', server: 'production'));

  void setUserName(String userName) {
    state = state.copyWith(
        userName: userName,
    );
  }

  void setPassword(String password) {
    state = state.copyWith(
        password: password,
    );
  }

  void setServer(String server) {
    state = state.copyWith(server: server);
  }

  bool validateSubmission(){
    String? userNameError;
    String? passwordError;

    if(state.userName.trim().isEmpty) {
      userNameError = "Username is required";
    }

    if(state.password.trim().isEmpty) {
      passwordError = "Password is required";
    }

    state = state.copyWith(
      userNameError: userNameError,
      passwordError: passwordError,
    );
    return userNameError == null && passwordError == null;
  }
}
