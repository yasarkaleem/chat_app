import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../services/hive_service.dart';
import '../../models/chat_room.dart';
import 'chat_room_event.dart';
import 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  ChatRoomBloc() : super(ChatRoomInitialState()) {
    on<CreateChatRoomEvent>(_onCreateChatRoom);
    on<LoadChatRoomsEvent>(_onLoadChatRooms);
    on<AddMemberToChatRoomEvent>(_onAddMemberToChatRoom);
  }

  Future<void> _onCreateChatRoom(
    CreateChatRoomEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      emit(ChatRoomLoadingState());
      final currentUser = HiveService.getCurrentUser();
      if (currentUser == null) {
        emit(const ChatRoomErrorState('User not found'));
        return;
      }

      final chatRoom = ChatRoom(
        id: const Uuid().v4(),
        name: event.name,
        creator: currentUser.id,
        members: [currentUser.id],
        createdAt: DateTime.now(),
      );

      await HiveService.saveChatRoom(chatRoom);
      add(const LoadChatRoomsEvent());
    } catch (e) {
      emit(ChatRoomErrorState('Error creating chat room: $e'));
    }
  }

  Future<void> _onLoadChatRooms(
    LoadChatRoomsEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      emit(ChatRoomLoadingState());
      final chatRooms = HiveService.getAllChatRooms();
      emit(ChatRoomLoadedState(chatRooms));
    } catch (e) {
      emit(ChatRoomErrorState('Error loading chat rooms: $e'));
    }
  }

  Future<void> _onAddMemberToChatRoom(
    AddMemberToChatRoomEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      final chatRoom = HiveService.getChatRoom(event.chatRoomId);
      if (chatRoom == null) {
        emit(const ChatRoomErrorState('Chat room not found'));
        return;
      }

      if (!chatRoom.members.contains(event.userId)) {
        final updatedMembers = [...chatRoom.members, event.userId];
        final updatedChatRoom = ChatRoom(
          id: chatRoom.id,
          name: chatRoom.name,
          creator: chatRoom.creator,
          members: updatedMembers,
          createdAt: chatRoom.createdAt,
        );

        await HiveService.saveChatRoom(updatedChatRoom);
        add(const LoadChatRoomsEvent());
      }
    } catch (e) {
      emit(ChatRoomErrorState('Error adding member: $e'));
    }
  }
}
