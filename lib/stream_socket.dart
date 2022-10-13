import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart';

// STEP1:  Stream setup
class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen() {
  var opt = OptionBuilder()
      .setTransports(['websocket'])
      .setPath("/ws")
      .disableAutoConnect()
      .setQuery({'tenantId': 2, 'protocol': 'sio1'})
      .build();

  Socket socket = io('https://test-micros1.play-online.com', opt);

  socket.onConnect((_) {
    print('connect');
    socket.emit('msg', 'test');
  });

  //When an event recieved from server, data is added to the stream
  socket.on('tournament_end', (data) => streamSocket.addResponse);
  socket.on('tournament_created', (data) => streamSocket.addResponse);

  socket.onDisconnect((_) => print('disconnect'));
}
