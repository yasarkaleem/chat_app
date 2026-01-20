import 'package:equatable/equatable.dart';
import '../../models/message.dart';

abstract class MessageState extends Equatable {
  const MessageState();
}

class MessageInitialState extends MessageState {
  @override
  List<Object?> get props => [];
}

class MessageLoadingState extends MessageState {
  @override
  List<Object?> get props => [];
}

class MessageLoadedState extends MessageState {
  final List<Message> messages;

  const MessageLoadedState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessageErrorState extends MessageState {
  final String message;

  const MessageErrorState(this.message);

  @override
  List<Object?> get props => [message];
}