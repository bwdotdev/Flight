part of flight;

class Request {

  HttpRequest request;

  Request(this.request);

  get path => request.uri.path;

  get headers => request.headers;

  get json => request.transform(Utf8Decoder()).map(jsonDecode);

}