import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

Future<MqttServerClient> connectMQTTClient({
  required String clientID,
  onConnected = _defaultOnConnected,
  onDisconnected = _defaultOnDisconnected,
  onSubscribed = _defaultOnSubscribed,
  onSubscribeFail = _defaultOnSubscribeFail,
  onUnsubscribed = _defaultOnUnsubscribed,
  onAutoReconnect = _defaultOnAutoReconnect,
  pong = _defaultPong,
}) async {
  MqttServerClient client =
      MqttServerClient.withPort('broker.hivemq.com', clientID, 1883);

  client.logging(on: true);
  client.autoReconnect = true;
  client.resubscribeOnAutoReconnect = true;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.onUnsubscribed = onUnsubscribed;
  client.onAutoReconnect = onAutoReconnect;
  client.onDisconnected = onDisconnected;
  client.pongCallback = pong;

  final String statusTopic = 'monitors/$clientID/status';

  final connMessage = MqttConnectMessage()
      .keepAliveFor(60)
      .withWillRetain()
      .withWillTopic(statusTopic)
      .startClean()
      .withWillMessage('offline')
      .withWillQos(MqttQos.exactlyOnce);
  client.connectionMessage = connMessage;

  try {
    await client.connect();
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }

  return client;
}

void _defaultOnConnected() {
  print('MQTT Client Connected');
}

void _defaultOnDisconnected() {
  print('MQTT Client Disconnected');
}

void _defaultOnSubscribed(String topic) {
  print('Subscribed topic: $topic');
}

void _defaultOnSubscribeFail(String topic) {
  print('Failed to subscribe $topic');
}

void _defaultOnUnsubscribed(String? topic) {
  print('Unsubscribed topic: $topic');
}

void _defaultPong() {
  print('Ping response client callback invoked');
}

void _defaultOnAutoReconnect() {
  print('Reconnecting...');
}
