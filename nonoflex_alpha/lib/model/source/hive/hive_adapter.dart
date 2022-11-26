import 'package:hive_flutter/adapters.dart';
import 'package:nonoflex_alpha/model/data/user.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 0;

  @override
  User read(BinaryReader reader) {
    return User.fromJson(reader.readMap() as Map<String, dynamic>);
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeMap(obj.toMap());
  }
}
