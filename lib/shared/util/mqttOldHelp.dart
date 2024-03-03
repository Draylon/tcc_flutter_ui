
//                      MQTT
//=============================================================

/*import 'package:mqtt_client/mqtt_client.dart';

void _mqttSubscribeToTopic(String topic) {
  print('[MQTT client] Subscribing to ${topic.trim()}');
  mqttServerClient.subscribe(topic, MqttQos.atMostOnce);
}

/*
  Conecta no servidor MQTT à partir dos dados configurados nos atributos desta classe (broker, port, etc...)
   */
_mqttConnect() async{
  if(mqttServerClient.connectionStatus?.state==MqttConnectionState.connected) return;
  mqttServerClient.keepAlivePeriod = 30;
  mqttServerClient.onDisconnected = _onMqttDisconnected;

  final MqttConnectMessage connMess = MqttConnectMessage()
      .withClientIdentifier('user_hyqnap5637')
      .startClean() // Non persistent session for testing
      .withWillQos(MqttQos.atMostOnce);
  print('[MQTT client] MQTT client connecting....');
  mqttServerClient.connectionMessage = connMess;

  try{
    await mqttServerClient.connect();
  }catch(e){
    print(e);
    print('[MQTT client] ERROR: MQTT client connection failed - '
        'disconnecting, state is ${mqttServerClient.connectionStatus?.state}');
  }
  mqttServerClient.connectionStatus?.state == MqttConnectionState.connected
      ?{print('[MQTT client] connected'),
    _mqttSubscribeToTopic('hyqnap5637/#')}
      : {
    print("couldn't connect?"),
    print(mqttServerClient.connectionStatus?.state),
    mqttDisconnect()
  };
}
Future _mqttConnect2() {
  if(mqttServerClient.connectionStatus?.state==MqttConnectionState.connected) return Future.value(mqttServerClient.connectionStatus);
  mqttServerClient.keepAlivePeriod = 30;
  mqttServerClient.onDisconnected = _onMqttDisconnected;

  final MqttConnectMessage connMess = MqttConnectMessage()
      .withClientIdentifier('user_hyqnap5637')
      .startClean() // Non persistent session for testing
      .withWillQos(MqttQos.atMostOnce);
  print('[MQTT client] MQTT client connecting....');
  mqttServerClient.connectionMessage = connMess;

  return mqttServerClient.connect().then((value) => {
    value?.state == MqttConnectionState.connected
        ?{print('[MQTT client] connected'),
      _mqttSubscribeToTopic('hyqnap5637/#')}
        : {
      print("couldn't connect?"),
      print(value?.state),
    },
  },onError: (e)=>{
    print(e),
    print('[MQTT client] ERROR: MQTT client connection failed - '
        'disconnecting, state is ${mqttServerClient.connectionStatus?.state}'),
    mqttDisconnect()
  });
}


/*
  Executa algo quando desconectado, no caso, zera as variáveis e imprime msg no console
   */
void _onMqttDisconnected() {
  print('[MQTT client] _onDisconnected');
  print('[MQTT client] MQTT client disconnected');
}

/*
  Escuta quando mensagens são escritas no tópico. É aqui que lê os dados do servidor MQTT e modifica o valor do termômetro
   */
void _onMqttMessage(List<MqttReceivedMessage> event) {
  print(event.length);
  final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
  final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
  print('[MQTT client] MQTT message: topic is <${event[0].topic}>, ''payload is <-- ${message} -->');
  print(mqttServerClient.connectionStatus?.state);
  print("[MQTT client] message with topic: ${event[0].topic}");
  print("[MQTT client] message with message: ${message}");
  _pushNotification(FlutterLocalNotificationsPlugin(),"BigStonks","ayylmao");
}

/*
  Desconecta do servidor MQTT
   */

void mqttDisconnect() {
  print('[MQTT client] _disconnect()');
  mqttServerClient.disconnect();
}*/