import 'package:equatable/equatable.dart';
import '../models/chat_room.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState();
}

class ChatRoomInitialState extends ChatRoomState {
  @override
  List<Object?> get props => [];
}

class ChatRoomLoadingState extends ChatRoomState {
  @override
  List<Object?> get props => [];
}

class ChatRoomLoadedState extends ChatRoomState {
  final List<ChatRoom> chatRooms;

  const ChatRoomLoadedState(this.chatRooms);

  @override
  List<Object?> get props => [chatRooms];
}

class ChatRoomErrorState extends ChatRoomState {
  final String message;

  const ChatRoomErrorState(this.message);

  @override
  List<Object?> get props => [message];
}