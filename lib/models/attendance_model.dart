class Attendance {
  final String? id;
  final String? personName;
  final String? personType;
  final String? companyName;
  final String? employeeId;
  final String? punchTime;
  final String? punchStatus;
  final String? sourceSystem;
  final bool? checkinWhatsappSent;
  final bool? checkoutWhatsappSent;
  final bool? absentWhatsappSent;
  final bool? isCalled;
  final String? callFeedback;
  final String? insertedAt;
  final int? company;

  Attendance({
    this.id,
    this.personName,
    this.personType,
    this.companyName,
    this.employeeId,
    this.punchTime,
    this.punchStatus,
    this.sourceSystem,
    this.checkinWhatsappSent,
    this.checkoutWhatsappSent,
    this.absentWhatsappSent,
    this.isCalled,
    this.callFeedback,
    this.insertedAt,
    this.company,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as String?,
      personName: json['person_name'] as String?,
      personType: json['person_type'] as String?,
      companyName: json['company_name'] as String?,
      employeeId: json['employee_id']?.toString(),
      punchTime: json['punch_time'] as String?,
      punchStatus: json['punch_status'] as String?,
      sourceSystem: json['source_system'] as String?,
      checkinWhatsappSent: json['checkin_whatsapp_sent'] as bool?,
      checkoutWhatsappSent: json['checkout_whatsapp_sent'] as bool?,
      absentWhatsappSent: json['absent_whatsapp_sent'] as bool?,
      isCalled: json['is_called'] as bool?,
      callFeedback: json['call_feedback']?.toString(),
      insertedAt: json['inserted_at'] as String?,
      company: json['company'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'person_name': personName,
      'person_type': personType,
      'company_name': companyName,
      'employee_id': employeeId,
      'punch_time': punchTime,
      'punch_status': punchStatus,
      'source_system': sourceSystem,
      'checkin_whatsapp_sent': checkinWhatsappSent,
      'checkout_whatsapp_sent': checkoutWhatsappSent,
      'absent_whatsapp_sent': absentWhatsappSent,
      'is_called': isCalled,
      'call_feedback': callFeedback,
      'inserted_at': insertedAt,
      'company': company,
    };
  }
}
