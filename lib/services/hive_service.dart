import 'package:hive_flutter/hive_flutter.dart';
import '../models/chat_room.dart';
import '../models/message.dart';
import '../models/user.dart';

class HiveService {
  static const String chatRoomsBox = 'chat_rooms';
  static const String messagesBox = 'messages';
  static const String usersBox = 'users';
  static const String currentUserBox = 'current_user';

  static Future<void> initHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ChatRoomAdapter());
    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(UserAdapter());

    await Hive.openBox<ChatRoom>(chatRoomsBox);
    await Hive.openBox<Message>(messagesBox);
    await Hive.openBox<User>(usersBox);
    await Hive.openBox(currentUserBox);
  }

  // User operations
  static Future<void> saveCurrentUser(User user) async {
    final box = Hive.box(currentUserBox);
    await box.put('user', user);
  }

  static User? getCurrentUser() {
    final box = Hive.box(currentUserBox);
    return box.get('user');
  }

  static Future<void> saveUser(User user) async {
    final box = Hive.box<User>(usersBox);
    await box.put(user.id, user);
  }

  static User? getUser(String userId) {
    final box = Hive.box<User>(usersBox);
    return box.get(userId);
  }

  static List<User> getAllUsers() {
    final box = Hive.box<User>(usersBox);
    return box.values.toList();
  }

  // ChatRoom operations
  static Future<void> saveChatRoom(ChatRoom chatRoom) async {
    final box = Hive.box<ChatRoom>(chatRoomsBox);
    await box.put(chatRoom.id, chatRoom);
  }

  static ChatRoom? getChatRoom(String chatRoomId) {
    final box = Hive.box<ChatRoom>(chatRoomsBox);
    return box.get(chatRoomId);
  }

  static List<ChatRoom> getAllChatRooms() {
    final box = Hive.box<ChatRoom>(chatRoomsBox);
    return box.values.toList();
  }

  static Future<void> deleteChatRoom(String chatRoomId) async {
    final box = Hive.box<ChatRoom>(chatRoomsBox);
    await box.delete(chatRoomId);
  }

  // Message operations
  static Future<void> saveMessage(Message message) async {
    final box = Hive.box<Message>(messagesBox);
    await box.put(message.id, message);
  }

  static List<Message> getMessagesForChatRoom(String chatRoomId) {
    final box = Hive.box<Message>(messagesBox);
    final messages = box.values
        .where((msg) => msg.chatRoomId == chatRoomId)
        .toList();
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  static Future<void> deleteMessagesForChatRoom(String chatRoomId) async {
    final box = Hive.box<Message>(messagesBox);
    final keysToDelete = box.keys
        .where((key) => box.get(key)?.chatRoomId == chatRoomId)
        .toList();
    for (var key in keysToDelete) {
      await box.delete(key);
    }
  }
}
