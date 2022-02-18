
import 'package:flutter_wan/database/AppDatabase.dart';

class DatabaseService {
  DatabaseService._internal();

  static DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService.ins() => _instance;
  AppDatabase? _database = null;

  Future<AppDatabase> getDatabase() async {
    if(_database == null) {
      return $FloorAppDatabase.databaseBuilder("app_database.db").build();
    }
    return Future.value(_database);
  }

}