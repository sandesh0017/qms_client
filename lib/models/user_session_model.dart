class UserSession {
  UserSession({
    this.clientCode,
    this.serviceCentreCode,
    this.serviceCentreName,
    this.koiskIdCode,
  });

  final String? clientCode;
  final int? serviceCentreCode;
  final String? serviceCentreName;
  final String? koiskIdCode;

  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
        clientCode: json["clientCode"],
        serviceCentreCode: json["serviceCentreCode"],
        serviceCentreName: json["serviceCentreName"],
        koiskIdCode: json["koiskIdCode"],
      );

  Map<String, dynamic> toJson() => {
        "clientCode": clientCode,
        "serviceCentreCode": serviceCentreCode,
        "serviceCentreName": serviceCentreName,
        "koiskIdCode": koiskIdCode,
      };
}
