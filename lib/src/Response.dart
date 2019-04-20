part of flight;

class Response {

  HttpResponse response;

  Response(this.response) {
    header('X-Powered-By', 'Flight (Dart)');
  }

  HttpHeaders get headers => response.headers;

  String header(String name, [ String value, bool ifNotExists = false ]) {
    if(value != null && (!ifNotExists || header(name) == null)) headers.set(name, value);

    return headers.value(name);
  }

  status(int status) {
    response.statusCode = status;
    return this;
  }

  void send(dynamic content) {
    if(content is Map) {
      header('Content-Type', 'application/json');
      response..write(jsonEncode(content))..close();
    } else {
      response..write(content)..close();
    }
  }

}