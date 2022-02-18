
import 'package:floor/floor.dart';

@entity
class History {
  @primaryKey
  final String id;
  final String articleInfo;
  final String idName;
  final int createTime;


  History(this.id, this.articleInfo, this.idName, {int? createTime}): this.createTime = createTime ?? DateTime.now().millisecondsSinceEpoch;
}