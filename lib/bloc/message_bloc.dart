import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../services/hive_service.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInitialState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<LoadMessagesEvent>(_onLoadMessages);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    try {
      final currentUser = HiveService.getCurrentUser();
      if (currentUser == null) {
        emit(const MessageErrorState('User not found'));
        return;
      }

      final message = Message(
        id: const Uuid().v4(),
        chatRoomId: event.chatRoomId,
        sender: currentUser.id,
        content: event.content,
        timestamp: DateTime.now(),
      );

      await HiveService.saveMessage(message);
      add(LoadMessagesEvent(event.chatRoomId));
    } catch (e) {
      emit(MessageErrorState('Error sending message: $e'));
    }
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    try {
      emit(MessageLoadingState());
      final messages = HiveService.getMessagesForChatRoom(event.chatRoomId);
      emit(MessageLoadedState(messages));
    } catch (e) {
      emit(MessageErrorState('Error loading messages: $e'));
    }
  }
}
