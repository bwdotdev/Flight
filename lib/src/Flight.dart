part of flight;

typedef RouteHandler = void Function(Request req, Response res1);
typedef BoundCallback = void Function(int port, String address);

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

  Flight({ int port = 3000, String address = '0.0.0.0', BoundCallback onBound }) {
    var listenOn = InternetAddress(address);

    HttpServer.bind(listenOn, port).then(
      (server) => this._serverBound(server, onBound),
    );
  }

  _serverBound(HttpServer server, BoundCallback onBound) async {
    if(onBound != null) onBound(server.port, server.address.address);

    await for (HttpRequest request in server) {
      var verb = this._getVerb(request.method);
      var req = Request(request);
      var res = Response(request.response);

      if(verb == null) {
        res.send('Unsupported Verb');
      } else {
        var verbRoutes = this._routes[verb];

        if(!verbRoutes.containsKey(req.path)) {
          res.status(404).send('Not found');
        } else {
          res.send(req.path);
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
