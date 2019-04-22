part of flight;

class Route {

  Verb verb;
  String path;
  RouteHandler _handler;

  Route(this.verb, this.path, this._handler);

  void call(Request req, Response res) => _handler(req, res);

}
