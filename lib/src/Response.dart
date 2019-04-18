part of flight;

class Response {

  HttpResponse response;

  Response(this.response);

  get headers => response.headers;

  status(int status) {
    response.statusCode = status;
    return this;
  }

  void send(dynamic content) {
    if(content is Map) {
      response.headers.set('Content-Type', 'application/json');
      response..write(jsonEncode(content))..close();
    } else {
      response..write(content)..close();
    }
  }

}