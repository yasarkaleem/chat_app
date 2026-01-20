import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'src/features/auth/screens/login_screen.dart';
import 'src/features/chat/bloc/message/message_bloc.dart';
import 'src/features/chat_room/bloc/chat_room/chat_room_bloc.dart';
import 'src/features/chat_room/screens/home_screen.dart';
import 'src/services/hive_service.dart';

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
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: HiveService.getCurrentUser() == null
          ? const LoginScreen()
          : const HomeScreen(),
    );
  }
}
