import 'package:hive/hive.dart';

part 'set_session.g.dart';

@HiveType(typeId: 1)
class SetSess {
  @HiveField(0)
  String? clientCode;

  @HiveField(1)
  int? serviceCentreCode;

  @HiveField(2)
  String? serviceCentreName;

  @HiveField(3)
  String? koiskIdCode;

  SetSess(
      {required this.clientCode,
      required this.koiskIdCode,
      required this.serviceCentreCode,
      required this.serviceCentreName});
}
