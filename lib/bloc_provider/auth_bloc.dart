import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_app/models/shop.dart';
import 'package:shop_app/utils/data_vault.dart';
import 'package:shop_app/utils/shared_preference_keys.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// authentication bloc
final AuthBloc Auth = AuthBloc();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  DataVault _secureStore = DataVault();
  static final AuthBloc _authBlocSingleton = AuthBloc._internal();

  factory AuthBloc() => _authBlocSingleton;

  AuthBloc._internal();

  @override
  AuthState get initialState {
    Future.delayed(Duration.zero, () => this.add(AppStarted()));
    return AuthUninitialized();
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      // get stored token and user data from secure storage
      String usr =
          await _secureStore.getStringValuesSF(SharedPreferenceKeys.user);
      String token =
          await _secureStore.getStringValuesSF(SharedPreferenceKeys.queueKey);
      final user = usr == null ? null : Shop.fromJson(json.decode(usr));
      if (user != null)
        yield Authenticated(token, user);
      else
        yield UnAuthenticated();
    } else if (event is LoggedIn) {
      yield Authenticated(event.token, event.user);
      _secureStore.addStringToSF(
          SharedPreferenceKeys.user, json.encode(event.user.toJson()));
      _secureStore.addStringToSF(
          SharedPreferenceKeys.queueKey, json.encode(event.token));
    } else if (event is signupIn) {
      yield AuthenticatedSignup(event.user, event.token);
      _secureStore.addStringToSF(
          SharedPreferenceKeys.user, json.encode(event.user.toJson()));
      _secureStore.addStringToSF(
          SharedPreferenceKeys.queueKey, json.encode(event.token));
    } else if (event is addToQueue) {
      _secureStore.addStringToSF(SharedPreferenceKeys.queueKey, event.queueId);
    } else if (event is LogOut) {
      _secureStore.removeValues(SharedPreferenceKeys.user);
      _secureStore.removeValues(SharedPreferenceKeys.queueKey);
      yield UnAuthenticated();
    } else if (event is UpdateUser)
      yield Authenticated(event.token, event.user);
  }

  @override
  Future<void> close() {
    _authBlocSingleton.close();
    return super.close();
  }

  auth() {}
}
