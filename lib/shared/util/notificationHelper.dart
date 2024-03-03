import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:ui/shared/util/mqttHelper.dart';
import 'package:workmanager/workmanager.dart';




Future queryGeneralNotificationChannel(FlutterLocalNotificationsPlugin flip) async {

  //await _pushNotification(flip);
  //if(1==1) return;

  Stream<List<MqttReceivedMessage<MqttMessage>>>? updates = await mqttStream();
  if (mqttServerClient.connectionStatus?.state == MqttConnectionState.connected) {
    print('[MQTT client] connected');

    if (topicFilterStream == null) {
      /*mqttStreams = updates?.listen((List<MqttReceivedMessage> event) {
        print(event.length);
        final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            recMess.payload.message);
        print('[MQTT client] MQTT message: topic is <${event[0]
            .topic}>, ''payload is <-- ${message} -->');
        print(mqttServerClient.connectionStatus?.state);
        print("[MQTT client] message with topic: ${event[0].topic}");
        print("[MQTT client] message with message: ${message}");
        _pushNotification(
            FlutterLocalNotificationsPlugin(), "BigStonks", "ayylmao");
      });*/

      // Create the topic filter
      topicFilter = MqttClientTopicFilter(
          'hyqnap5637/general_updates', updates);
      // Now listen on the filtered updates, not the client updates

      topicFilterStream=topicFilter?.updates.listen((List<MqttReceivedMessage<MqttMessage?>> c) async {
        final recMess = c[0].payload as MqttPublishMessage;
        final pt = MqttPublishPayload.bytesToStringAsString(
            recMess.payload.message);

        print('[MQTT client] MQTT message: topic is <${c[0]
            .topic}>, ''payload is <-- ${pt} -->');
        print(mqttServerClient.connectionStatus?.state);
        print("[MQTT client] message with topic: ${c[0].topic}");
        print("[MQTT client] message with message: ${pt}");

        await pushNotification(flip, 'MQTT message', pt);
      }, onError: (e) => print(e),
        onDone: () => {
          print("Mqtt done successfully")
      });

      print("start loop waiting");
      await Future.delayed(const Duration(minutes: 14,seconds: 59));
      print("done waiting");

      /*topicFilter?.updates.forEach((List<MqttReceivedMessage<MqttMessage?>> c) async {
          final recMess = c[0].payload as MqttPublishMessage;
          final pt = MqttPublishPayload.bytesToStringAsString(
              recMess.payload.message);

          print('[MQTT client] MQTT message: topic is <${c[0]
              .topic}>, ''payload is <-- ${pt} -->');
          print(mqttServerClient.connectionStatus?.state);
          print("[MQTT client] message with topic: ${c[0].topic}");
          print("[MQTT client] message with message: ${pt}");

          await _pushNotification(flip, 'MQTT message', pt);
      });*/
    }
  }else{
    print("HOW IS IT NOT CONNECTED?");
  }

  /*topicFilter.updates.listen((List<MqttReceivedMessage<MqttMessage?>> c) {
    final recMess = c[0].payload as MqttPublishMessage;
    final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print(
        'EXAMPLE::Filtered Change notification for hyqnap5637/general_updates:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    print('');
  },cancelOnError: true);*/
}

Future<void> pushNotification(FlutterLocalNotificationsPlugin flip,String title,String desc) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '','Emergency Channel',channelDescription: 'General alert notifications',
      importance: Importance.max,
      fullScreenIntent: true,
      styleInformation: BigTextStyleInformation("bigText"),
      subText: "random alert"
  );
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
  await flip.show(0, title,
      desc,
      platformChannelSpecifics, payload: 'Default_Sound'
  );
}