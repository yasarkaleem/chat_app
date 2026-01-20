import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  const User({required this.id, required this.name, required this.email});

  @override
  List<Object?> get props => [id, name, email];
}
