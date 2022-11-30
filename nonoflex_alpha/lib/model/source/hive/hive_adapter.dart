import 'package:hive_flutter/adapters.dart';
import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/data/user.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 0;

  @override
  User read(BinaryReader reader) {
    return User.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeMap(obj.toMap());
  }
}

class AuthTokenAdapter extends TypeAdapter<AuthToken> {
  @override
  final typeId = 1;

  @override
  AuthToken read(BinaryReader reader) {
    return AuthToken.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, AuthToken obj) {
    writer.writeMap(obj.toMap());
  }
}
