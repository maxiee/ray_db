import 'package:ray_db/src/collection.dart';

class SelectorBuilder {
  SelectorBuilder(this._collection);

  Collection _collection;

  int? _limit;
  int? _skip;

  List<_Expression> _expressions = [];

  List<Map<String, dynamic>> findAll() {
    final ret = _collection.db.select(toSQL());
    if (ret.isNotEmpty) {
      return ret;
    } else {
      return [];
    }
  }

  Map<String, dynamic>? findFirst() {
    final ret = _collection.db.select(toSQL());
    if (ret.isNotEmpty) {
      return ret.first;
    }
  }

  // equal
  SelectorBuilder eq(String column, dynamic value) {
    _expressions.add(_Expression(column, value, _ExpressionType.eq));
    return this;
  }

  // not equal
  SelectorBuilder ne(String column, dynamic value) {
    _expressions.add(_Expression(column, value, _ExpressionType.ne));
    return this;
  }

  // greater than
  SelectorBuilder gt(String column, dynamic value) {
    _expressions.add(_Expression(column, value, _ExpressionType.gt));
    return this;
  }

  // less than
  SelectorBuilder lt(String column, dynamic value) {
    _expressions.add(_Expression(column, value, _ExpressionType.lt));
    return this;
  }

  // greater than or equal
  SelectorBuilder gte(String column, dynamic value) {
    _expressions.add(_Expression(column, value, _ExpressionType.gte));
    return this;
  }

  // less than or equal
  SelectorBuilder lte(String column, dynamic value) {
    _expressions.add(_Expression(column, value, _ExpressionType.lte));
    return this;
  }

  SelectorBuilder limit(int limit) {
    this._limit = limit;
    return this;
  }

  SelectorBuilder skip(int skip) {
    this._skip = _skip;
    return this;
  }

  SelectorBuilder and() {
    _expressions.add(_Expression("", limit, _ExpressionType.and));
    return this;
  }

  SelectorBuilder or() {
    _expressions.add(_Expression("", limit, _ExpressionType.or));
    return this;
  }

  String toSQL() {
    StringBuffer sb = StringBuffer();
    sb.write("SELECT ${_collection.columns.keys.join(',')} ");
    sb.write("FROM ${_collection.collection}");
    if (_expressions.isNotEmpty) {
      sb.write(" WHERE ");
      int current = 0;
      while (current < _expressions.length) {
        _Expression e = _expressions[current];
        sb.write(_expression2SQL(e));

        if (current + 1 < _expressions.length) {
          if (_expressions[current + 1].type == _ExpressionType.or) {
            sb.write(' OR ');
            current++;
          } else if (_expressions[current + 1].type == _ExpressionType.and) {
            sb.write(' AND ');
            current++;
          } else {
            // allow use to ignore explicit 'and'
            sb.write(' AND ');
          }
        }
        current++;
      }
    }
    if (_limit != null) {
      sb.write(' LIMIT $_limit');
    }
    if (_skip != null) {
      sb.write(' SKIP $_skip');
    }
    sb.write(';');
    return sb.toString();
  }

  String _expression2SQL(_Expression e) {
    dynamic value = e.value;
    if (value is String) {
      value = "'$value'";
    }
    switch (e.type) {
      case _ExpressionType.eq:
        return "${e.column} = $value";
      case _ExpressionType.ne:
        return "${e.column} != $value";
      case _ExpressionType.gt:
        return "${e.column} > $value";
      case _ExpressionType.lt:
        return "${e.column} < $value";
      case _ExpressionType.gte:
        return "${e.column} >= $value";
      case _ExpressionType.lte:
        return "${e.column} <= $value";
      case _ExpressionType.and:
      case _ExpressionType.or:
      default:
        throw FormatException("invalid expression ${e.toString()}");
    }
  }
}

enum _ExpressionType { eq, ne, gt, lt, gte, lte, and, or }

class _Expression {
  _Expression(this.column, this.value, this.type);

  String column;
  dynamic value;
  _ExpressionType type;

  @override
  String toString() {
    return '[$column][$value][$type]';
  }
}
