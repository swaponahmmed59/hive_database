import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String price;

  NoteModel({required this.name, required this.price});
}
