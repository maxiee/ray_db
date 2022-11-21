import 'package:ray_db/src/constants.dart';

abstract class DataUtils {
  static DataType parseType(String type) {
    switch (type) {
      case "INTEGER":
        return DataType.INTEGER;
      default:
        throw FormatException();
    }
  }
}
