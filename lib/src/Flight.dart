part of flight;

typedef RouteHandler = Future<void> Function(Request req, Response res1);
typedef BoundCallback = void Function(int port, String address);

enum Verb {
  GET,
  POST,
  PUT,
  DELETE,
}
const GET = Verb.GET;
const POST = Verb.POST;
const PUT = Verb.PUT;
const DELETE = Verb.DELETE;

class Flight {
  Map<Verb, Map<String, Route>> _routes = {
    GET: {},
    POST: {},
    PUT: {},
    DELETE: {},
  };

  Flight({
    int port = 3000,
    String address = '0.0.0.0',
    BoundCallback onBound,
    bool healthcheckEndpoint = true,
  }) {
    var listenOn = InternetAddress(address);

    if (healthcheckEndpoint) _registerHealthcheck();

    HttpServer.bind(listenOn, port).then(
      (server) => _serverBound(server, onBound),
    );
  }

  _registerHealthcheck() {
    _registerRoute(GET, '/hc', (req, res) {
      res.send({
        'status': 'ALIVE',
        'poweredBy': 'Flight',
      });
    });
  }

  _getJSONBody(HttpRequest request) async {
    return request.contentLength > 0 &&
            request.headers.contentType.value == ContentType.json.mimeType
        ? jsonDecode(await request.transform(Utf8Decoder()).join()) as Map
        : null;
  }

  _serverBound(HttpServer server, BoundCallback onBound) async {
    if (onBound != null) onBound(server.port, server.address.address);

    await for (HttpRequest request in server) {
      var verb = _getVerb(request.method);
      var req = Request(request);
      var res = Response(request.response);

      req.body = await _getJSONBody(request);

      if (verb == null) {
        res.send('Unsupported Verb');
      } else {
        var verbRoutes = _routes[verb];

        if (!verbRoutes.containsKey(req.path)) {
          res.status(404).send('Not found');
        } else {
          verbRoutes[req.path](req, res);
        }
      }
    }
  }

  Verb _getVerb(String verb) =>
      Verb.values.firstWhere((v) => v.toString() == 'Verb.' + verb);

  group(String base, List<Route> routes) {
    base = fixPath(base);

    routes.forEach((route) {
      _routes[route.verb].remove(route.path);
      route.path = base + route.path;
      _routes[route.verb][route.path] = route;
    });
  }

  Route call(Verb verb, String path, RouteHandler handler) =>
      _registerRoute(verb, path, handler);

  Route get(String path, RouteHandler handler) =>
      _registerRoute(GET, path, handler);

  Route post(String path, RouteHandler handler) =>
      _registerRoute(POST, path, handler);

  Route put(String path, RouteHandler handler) =>
      _registerRoute(PUT, path, handler);

  Route delete(String path, RouteHandler handler) =>
      _registerRoute(DELETE, path, handler);

  Route _registerRoute(Verb verb, String path, RouteHandler handler) {
    path = fixPath(path);

    return _routes[verb][path] = Route(verb, path, handler);
  }
}
