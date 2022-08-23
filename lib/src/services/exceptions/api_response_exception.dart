class ApiResponseException implements Exception {
  dynamic payload;
  String message;
  ApiResponseException(this.message, {this.payload});

  String getMessage() {
    return message;
  }

  dynamic getPayload() => payload;

  @override
  String toString() {
   return getMessage();
  }
}