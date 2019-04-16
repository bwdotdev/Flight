part of flight;

typedef RouteHandler = void Function();

enum Verb {
  GET, POST, PUT, DELETE,
}
const GET = Verb.GET;
const POST = Verb.POST;
const PUT = Verb.PUT;
const DELETE = Verb.DELETE;

class Flight {

  Map<Verb, Map<String, RouteHandler>> _routes = {
    GET: {},
    POST: {},
    PUT: {},
    DELETE: {},
  };

  Flight([ int port = 3000, String address = '0.0.0.0' ]) {
    var listenOn = InternetAddress(address);

    HttpServer.bind(listenOn, port).then(this._serverBound);
  }

  _serverBound(HttpServer server) async {
    print('bound');

    await for (HttpRequest request in server) {
      var verb = this._getVerb(request.method);
      var res = request.response;

      if(verb == null) {
        res..write('Unsupported Verb')..close();
      } else {
        var verbRoutes = this._routes[verb];

        if(!verbRoutes.containsKey(request.uri.path)) {
          res.statusCode = 404;
          res..write('Not found')..close();
        } else {
          request.response
            ..write(request.uri)
            ..close();
        }
      }
    }
  }

  Verb _getVerb(String verb) {
    verb = verb.toUpperCase();
    if(verb == 'GET') return GET;
    if(verb == 'POST') return POST;
    if(verb == 'PUT') return PUT;
    if(verb == 'DELETE') return DELETE;

    return null;
  }

  call(Verb verb, String path, RouteHandler handler) {
    if(verb == GET) return this.get(path, handler);
    if(verb == POST) return this.post(path, handler);
    if(verb == PUT) return this.put(path, handler);
    if(verb == DELETE) return this.delete(path, handler);
  }

  get(String path, RouteHandler handler) {
    this._registerRoute(GET, path, handler);
  }

  post(String path, RouteHandler handler) {
    this._registerRoute(POST, path, handler);
  }

  put(String path, RouteHandler handler) {
    this._registerRoute(PUT, path, handler);
  }

  delete(String path, RouteHandler handler) {
    this._registerRoute(DELETE, path, handler);
  }

  _registerRoute(Verb verb, String path, RouteHandler handler) {
    this._routes[verb][path] = handler;
  }

}
