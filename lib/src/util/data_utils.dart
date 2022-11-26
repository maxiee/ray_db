import 'package:ray_db/src/constants.dart';

abstract class DataUtils {
  static InnerDataType parseType(String type) {
    switch (type) {
      case "INTEGER":
        return InnerDataType.INTEGER;
      case "TEXT":
        return InnerDataType.TEXT;
      default:
        throw FormatException();
    }
  }

  static InnerDataType parseObjType(dynamic obj) {
    if (obj is int) {
      return InnerDataType.INTEGER;
    } else if (obj is String) {
      return InnerDataType.TEXT;
    }
    throw FormatException("unsupported object type ${obj.toString()}");
  }
}
