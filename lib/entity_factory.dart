import 'package:wanandroid_flutter/entity/article_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "ArticleEntity") {
      return ArticleEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}
