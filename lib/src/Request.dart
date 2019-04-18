part of flight;

class Request {

  HttpRequest request;
  
  Map body;

  Request(this.request, this.body);

  String get path => request.uri.path;

  HttpHeaders get headers => request.headers;

}