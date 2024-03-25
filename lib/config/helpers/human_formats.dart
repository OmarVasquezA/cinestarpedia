import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number, [int decimals = 0]) {
    final formatterNumber =
        NumberFormat.compactCurrency(decimalDigits: decimals, symbol: '', locale: 'en')
            .format(number);

    return formatterNumber;
  }

  static String numberVotes(double number) {
    final formatterNumberVotes =
        NumberFormat.compactCurrency(decimalDigits: 1, symbol: '')
            .format(number);

    return formatterNumberVotes;
  }
}
