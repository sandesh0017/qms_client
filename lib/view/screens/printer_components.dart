import 'package:intl/intl.dart';

final DateTime now = DateTime.now();
final DateFormat eDate = DateFormat('yyyy-MM-dd');
final String excelDate = eDate.format(now);
String excelTime = DateFormat("hh:mm:ss").format(now);
