import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/chat_room_bloc.dart';
import '../bloc/chat_room_event.dart';
import '../bloc/chat_room_state.dart';

class CreateChatRoomScreen extends StatefulWidget {
  const CreateChatRoomScreen({super.key});

  @override
  State<CreateChatRoomScreen> createState() => _CreateChatRoomScreenState();
}

class _CreateChatRoomScreenState extends State<CreateChatRoomScreen> {
  final _roomNameController = TextEditingController();
  late ChatRoomBloc _chatRoomBloc;

  @override
  void initState() {
    super.initState();
    _chatRoomBloc = GetIt.instance<ChatRoomBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Chat Room')),
      body: BlocListener<ChatRoomBloc, ChatRoomState>(
        bloc: _chatRoomBloc,
        listener: (context, state) {
          if (state is ChatRoomLoadedState) {
            Navigator.pop(context);
          } else if (state is ChatRoomErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _roomNameController,
                decoration: const InputDecoration(
                  labelText: 'Chat Room Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createRoom,
                child: const Text('Create Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createRoom() {
    if (_roomNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a room name')));
      return;
    }

    _chatRoomBloc.add(CreateChatRoomEvent(_roomNameController.text));
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }
}
