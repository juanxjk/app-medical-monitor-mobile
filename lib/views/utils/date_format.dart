import 'package:intl/intl.dart';

String formatDateInFullPTBR(DateTime date) {
  return DateFormat("d 'de' MMMM 'de' y", "pt_BR").format(date);
}
