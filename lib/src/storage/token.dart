import 'package:objectbox/objectbox.dart';

@Entity()
class Token {
  @Id(assignable: true)
  int id = 0;

  String accessToken;
  String refreshToken;

  Token({required this.accessToken, required this.refreshToken});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
