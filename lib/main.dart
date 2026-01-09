import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ticketbooking/pages/common/splashscreen.dart';
import 'package:ticketbooking/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  runApp(
    const MaterialApp(home: Splashscreen(), debugShowCheckedModeBanner: false),
  );
}
