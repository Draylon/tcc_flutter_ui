import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

StreamSubscription? mqttStreams;
MqttClientTopicFilter? topicFilter;
StreamSubscription? topicFilterStream;
MqttServerClient mqttServerClient = MqttServerClient.withPort("test.mosquitto.org", "user_hyqnap5637", 1883);

Future<Stream<List<MqttReceivedMessage<MqttMessage>>>?> mqttStream() async {
  try{
      print("querying current state:");
      print(mqttServerClient.connectionStatus?.state);
      if(mqttServerClient.connectionStatus?.state == MqttConnectionState.connected) return Future.value(mqttServerClient.updates);
  }catch(e,stackTrace){
    print("mqtt initialize error");
    print(e);
    print(stackTrace);
  }
  print("MQTT initializing:");
  mqttServerClient.keepAlivePeriod = 30;
  mqttServerClient.autoReconnect = true;

  mqttServerClient.onConnected = () {
    print('MQTT connected');
  };

  mqttServerClient.onDisconnected = () {
    print('MQTT disconnected');
  };

  mqttServerClient.onSubscribed = (String topic) {
    print('MQTT subscribed to $topic');
  };

  return mqttServerClient.connect().then((conStatus) {
    if(conStatus?.state==MqttConnectionState.connected){
      mqttServerClient.subscribe("hyqnap5637/#", MqttQos.atLeastOnce);
      print("MQTT initialize successfully");

      mqttServerClient.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          final recMess = c![0].payload as MqttPublishMessage;
          final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          print("message payload => " + pt);
        });

      return mqttServerClient.updates;
    }else{
      print("STILL NOT CONNECTED?");
      return null;
    }
  },onError: (error, stackTrace) {
    print("error -> $error");
    print(stackTrace);
  });

  /*if (mqttServerClient.connectionStatus!.state == MqttConnectionState.connected) {

  }else{
    print("MQTT failed connecting");
    return null;
  }*/
}