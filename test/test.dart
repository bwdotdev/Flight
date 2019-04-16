import 'package:flight/flight.dart';

void main() {
  
  Flight f = Flight(
    onBound: (port, addr) => print('Listening on ${addr}:${port}'),
  );

  f.get('/test', (req, res) {

  });

  f.post('/test', (req, res) {

  });

  f(PUT, '/test', (req, res) {

  });

}
