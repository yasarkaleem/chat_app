import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/chat_room/chat_room_bloc.dart';
import '../bloc/chat_room/chat_room_event.dart';
import '../../chat/screens/chat_screen.dart';
import '../bloc/chat_room/chat_room_state.dart';
import 'create_chat_room_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ChatRoomBloc _chatRoomBloc;

  @override
  void initState() {
    super.initState();
    _chatRoomBloc = GetIt.instance<ChatRoomBloc>();
    _chatRoomBloc.add(const LoadChatRoomsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Rooms')),
      body: BlocBuilder<ChatRoomBloc, ChatRoomState>(
        bloc: _chatRoomBloc,
        builder: (context, state) {
          if (state is ChatRoomLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatRoomLoadedState) {
            if (state.chatRooms.isEmpty) {
              return const Center(child: Text('No chat rooms yet'));
            }
            return ListView.builder(
              itemCount: state.chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = state.chatRooms[index];
                return ListTile(
                  title: Text(chatRoom.name),
                  subtitle: Text('Members: ${chatRoom.members.length}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(chatRoom: chatRoom),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is ChatRoomErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreateChatRoomScreen(),
            ),
          );//.then((_) => _chatRoomBloc.add(const LoadChatRoomsEvent()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}