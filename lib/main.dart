import 'package:chat_app/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../bloc/chat_room_bloc.dart';
import '../bloc/message_bloc.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();
  _setupServiceLocator();
  runApp(const MyApp());
}

void _setupServiceLocator() {
  final getIt = GetIt.instance;
  getIt.registerSingleton<ChatRoomBloc>(ChatRoomBloc());
  getIt.registerSingleton<MessageBloc>(MessageBloc());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: HiveService.getCurrentUser() == null
          ? const LoginScreen()
          : const HomeScreen(),
    );
  }
}
