import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class SendMessageEvent extends MessageEvent {
  final String chatRoomId;
  final String content;

  const SendMessageEvent(this.chatRoomId, this.content);

  @override
  List<Object?> get props => [chatRoomId, content];
}

class LoadMessagesEvent extends MessageEvent {
  final String chatRoomId;

  const LoadMessagesEvent(this.chatRoomId);

  @override
  List<Object?> get props => [chatRoomId];
}
