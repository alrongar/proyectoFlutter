import 'package:eventify_flutter/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{

  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications()async{
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('token $fCMToken');
  }

  void handleMessage (RemoteMessage? message){
    if(message == null) return;

    navigatorkey.currentState?.pushNamed("/map",arguments: message);
  }

  Future initPushNotification()async{
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}