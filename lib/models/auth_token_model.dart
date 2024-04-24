class AuthToken {
  String accessToken;
  String refreshToken;

  AuthToken({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
