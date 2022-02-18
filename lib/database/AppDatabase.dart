import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter_wan/database/DatabaseEntity.dart';
import 'package:flutter_wan/database/HistoryDao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'AppDatabase.g.dart'; // the generated code will be there

@Database(version: 1, entities: [History])
abstract class AppDatabase extends FloorDatabase {
  HistoryDao get historyDao;
}
