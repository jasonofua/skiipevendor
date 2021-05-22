part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AppStarted extends AuthEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthEvent {
  final Shop user;
  final String token;

  LoggedIn(this.user, this.token);

  @override
  List<Object> get props => [user, token];

  @override
  String toString() => 'LoggedIn';
}

class signupIn extends AuthEvent {
  final Shop user;
  final String token;

  signupIn(this.token, this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'signupIn';
}

class addToQueue extends AuthEvent {
  final String queueId;

  addToQueue(this.queueId);

  @override
  List<Object> get props => [queueId];

  @override
  String toString() => 'addToQueue';
}

class LogOut extends AuthEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'LogOut';
}

class UpdateUser extends AuthEvent {
  final Shop user;
  final String token;

  UpdateUser(this.token, this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UpdateUser';
}
