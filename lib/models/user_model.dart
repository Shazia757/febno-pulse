class Users {
  String? id;
  String? name;
  // String? company;

  Users({this.id, this.name});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(id: json['user_id']?.toString(), name: json['username'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'username': name};
  }
}

class LoginResponse {
  String? accessToken;
  String? refreshToken;
  Users? data;

  ///TODO- change to required
  LoginResponse({this.data, this.accessToken, this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      // data: json['user'] != null
      //     ? Users.fromJson(json['user'] as Map<String, dynamic>)
      //     : Users(),
      accessToken: json['access'] as String?,
      refreshToken: json['refresh'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'access': accessToken};
  }
}
