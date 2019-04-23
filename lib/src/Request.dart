part of flight;

class Request {
  HttpRequest request;

  Map body;

  Request(this.request, [this.body]);

  String get path => fixPath(request.uri.path);

  int get bodyLength => request.contentLength;

  HttpHeaders get headers => request.headers;

  String header(String name) => headers.value(name);
}
