class Users {
  String? id;
  String? name;
  String? company;
  String? email;
  bool? isSuperuser;
  bool? isManager;
  bool? isAccountant;

  Users({
    this.id,
    this.name,
    this.company,
    this.email,
    this.isSuperuser,
    this.isManager,
    this.isAccountant,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['user_id']?.toString(),
      name: json['username'] as String?,
      company: json['company'] as String?,
      email: json['email'] as String?,
      isSuperuser: json['is_superuser'] as bool?,
      isManager: json['is_manager'] as bool?,
      isAccountant: json['is_accountant'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'username': name,
      'company': company,
      'email': email,
      'is_superuser': isSuperuser,
      'is_manager': isManager,
      'is_accountant': isAccountant,
    };
  }
}
class LoginResponse {
  String? accessToken;
  String? refreshToken;
  Users? data;

  LoginResponse({this.data, this.accessToken, this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
    data: Users.fromJson(json),
      accessToken: json['access'] as String?,
      refreshToken: json['refresh'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'access': accessToken};
  }
}
