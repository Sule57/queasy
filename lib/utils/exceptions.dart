class UserAlreadyExistsException implements Exception {
  String errMsg() => 'User with this username already exists';
}

/// Exception thrown when the user is not logged in.
class UserNotLoggedInException implements Exception {
  String errMsg() => 'User is not logged in';
}
