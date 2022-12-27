class UserDoesNotExistException implements Exception {
  String errMsg() => 'This user does not exist';

}

class UserNotLoggedInException implements Exception {
  String errMsg() => 'User is not logged ';

}

class UserAlreadyExistsException implements Exception{
  String errMsg() => 'User with this username already exist ';
}