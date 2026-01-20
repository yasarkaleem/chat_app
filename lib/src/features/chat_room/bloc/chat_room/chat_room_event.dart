import 'package:equatable/equatable.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();
}

class CreateChatRoomEvent extends ChatRoomEvent {
  final String name;

  const CreateChatRoomEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class LoadChatRoomsEvent extends ChatRoomEvent {
  const LoadChatRoomsEvent();

  @override
  List<Object?> get props => [];
}

class AddMemberToChatRoomEvent extends ChatRoomEvent {
  final String chatRoomId;
  final String userId;

  const AddMemberToChatRoomEvent(this.chatRoomId, this.userId);

  @override
  List<Object?> get props => [chatRoomId, userId];
}