// Nono Server의 에러를 처리한다.
enum APIExceptionType{
  // common
  timeOutException,

  // nono server - v0.1

}

class APIException implements Exception{
  final message; // type? TODO:

  APIException([this.message]);

  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}