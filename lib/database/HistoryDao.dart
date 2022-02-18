
import 'package:floor/floor.dart';
import 'package:flutter_wan/database/DatabaseEntity.dart';

@dao
abstract class HistoryDao {

  @Query('SELECT * from History order by createTime')
  Future<List<History>> queryHistory();

  @Query('SELECT * from History order by createTime desc limit :limit offset :offset')
  Future<List<History>> queryHistoryByPage(int offset, int limit);

  @insert
  Future<void> insertHistory(History history);
}