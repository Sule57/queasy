
class UserAlreadyExistsException implements Exception {
  String errMsg() => 'User with this username already exists';
}