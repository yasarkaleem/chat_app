import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'chat_room.g.dart';

@HiveType(typeId: 0)
class ChatRoom extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String creator;

  @HiveField(3)
  final List<String> members;

  @HiveField(4)
  final DateTime createdAt;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.creator,
    required this.members,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, creator, members, createdAt];
}
