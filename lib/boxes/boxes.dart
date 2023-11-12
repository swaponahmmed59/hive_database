import 'package:hive_database/models/note_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<NoteModel> getData() => Hive.box<NoteModel>('note');
}
