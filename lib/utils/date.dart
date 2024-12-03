import 'package:intl/intl.dart';

class DateUtilsConverter {
  final DateTime utcDate;

  DateUtilsConverter(this.utcDate);

  DateTime get localDate => utcDate.toLocal();

  String get formattedDate => DateFormat.yMd().add_Hms().format(localDate);

  String get onlyHour => DateFormat.Hm().format(localDate);

  String get onlyDate => DateFormat.yMd().format(localDate);

  String get dayOfWeek => DateFormat.EEEE().format(localDate);
}