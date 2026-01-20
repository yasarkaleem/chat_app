import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'message.g.dart';

@HiveType(typeId: 1)
class Message extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String chatRoomId;

  @HiveField(2)
  final String sender;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.chatRoomId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, chatRoomId, sender, content, timestamp];
}