part of flight;

class Response {

  HttpResponse response;

  Response(this.response);

  get headers => response.headers;

  status(int status) {
    response.statusCode = status;
    return this;
  }

  void send(dynamic content) => response..write(content)..close();

}