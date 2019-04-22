part of flight;

class Route {

  String path;
  RouteHandler _handler;

  Route(this.path, this._handler);

  void call(Request req, Response res) => _handler(req, res);

}
