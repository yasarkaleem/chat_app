import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../models/chat_room.dart';
import '../services/hive_service.dart';
import '../bloc/chat_room_bloc.dart';
import '../bloc/chat_room_event.dart';
import '../bloc/chat_room_state.dart';

class InviteMembersScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const InviteMembersScreen({super.key, required this.chatRoom});

  @override
  State<InviteMembersScreen> createState() => _InviteMembersScreenState();
}

class _InviteMembersScreenState extends State<InviteMembersScreen> {
  late ChatRoomBloc _chatRoomBloc;

  @override
  void initState() {
    super.initState();
    _chatRoomBloc = GetIt.instance<ChatRoomBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final allUsers = HiveService.getAllUsers();
    final availableUsers = allUsers
        .where((user) => !widget.chatRoom.members.contains(user.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Invite Members')),
      body: BlocListener<ChatRoomBloc, ChatRoomState>(
        bloc: _chatRoomBloc,
        listener: (context, state) {
          if (state is ChatRoomLoadedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Member added successfully')),
            );
          } else if (state is ChatRoomErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: availableUsers.isEmpty
            ? const Center(child: Text('No available users to invite'))
            : ListView.builder(
                itemCount: availableUsers.length,
                itemBuilder: (context, index) {
                  final user = availableUsers[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _chatRoomBloc.add(
                          AddMemberToChatRoomEvent(widget.chatRoom.id, user.id),
                        );
                      },
                      child: const Text('Invite'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
