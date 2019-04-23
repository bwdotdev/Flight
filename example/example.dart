import 'package:flight/flight.dart';

void main() {
  Flight f = Flight(
    onBound: (port, addr) => print('Listening on ${addr}:${port}'),
  );

  f(GET, '/test', (req, res) {
    res.send('test');
  });

  f(POST, '/test', (req, res) {
    res.send(req.body);
  });

  f(PUT, '/test', (req, res) {});

  f.group('/group', [
    f(GET, '/child-1', (req, res) {
      res.send('child 1');
    }),
    f(GET, '/child-2', (req, res) {
      res.send('child 2');
    })
  ]);
}
