abstract class BaseException implements Exception {
  final String message;

  BaseException(this.message);
}

class UnknownException extends BaseException {
  UnknownException([super.message = 'Unknown Exception']);
}

class ServerException extends BaseException {
  ServerException([super.message = 'Internal Server Error, call the admin']);
}

class WrongCredentials extends BaseException {
  WrongCredentials([super.message = "Wrong Credentials"]);
}

class NoUserFound extends BaseException {
  NoUserFound([super.message = "No User Found"]);
}

// ex for invalid token
class InvalidToken extends BaseException {
  InvalidToken([super.message = "Invalid Token"]);
}

//ex for 404
class NotFoundException extends BaseException {
  NotFoundException([super.message = "Not Found"]);
}

//ex when no todos in local storage
class NoTodosException extends BaseException {
  NoTodosException([super.message = "No Todos Found"]);
}
