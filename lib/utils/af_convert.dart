import 'package:intl/intl.dart';

abstract class AFconvert {
  static String keString(dynamic nilai) {
    if (nilai != null) {
      return nilai.toString();
    } else {
      return '';
    }
  }

  static int keInt(dynamic nilai) {
    if (nilai != null) {
      return int.parse(nilai);
    } else {
      return 0;
    }
  }

  static double keDouble(dynamic nilai) {
    if (nilai != null) {
      return double.parse(nilai);
    } else {
      return 0;
    }
  }

  static bool keBool(dynamic nilai) {
    if (nilai != null) {
      if (nilai is String) {
        return nilai == 'Y' ? true : false;
      } else {
        return nilai;
      }
    } else {
      return false;
    }
  }

  static DateTime? keTanggal(dynamic nilai) {
    if (nilai != null && nilai != '') {
      return DateTime.parse(nilai);
    } else {
      return null;
    }
  }

  static List keList(dynamic nilai) {
    if (nilai != null) {
      if (nilai is String) {
        return nilai.split(',');
      } else {
        return nilai.toString().split(',');
      }
    } else {
      return [];
    }
  }

  static String matDateTime(DateTime? nilai) {
    final mat = DateFormat('dd-MM-yyyy HH:mm');
    return nilai != null ? mat.format(nilai) : '';
  }

  static String matDate(DateTime? nilai) {
    final mat = DateFormat('dd-MM-yyyy');
    return nilai != null ? mat.format(nilai) : '';
  }

  static String matTime(DateTime nilai) {
    final mat = DateFormat('HH:mm');
    return mat.format(nilai);
  }

  static String matDateYMD(DateTime nilai) {
    final mat = DateFormat('yyyy-MM-dd');
    return mat.format(nilai);
  }
}
