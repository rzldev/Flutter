class HttpException implements Exception {
  final String message;

  const HttpException({this.message});

  @override
  String toString() {
    // TODO: implement toString
    // return super.toString();

    return this.message;
  }
}
