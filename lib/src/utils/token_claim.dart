import 'package:jwt_decode_full/jwt_decode_full.dart';
import 'package:simple_chat/main.dart';

class TokenClaims {
  final token = tokenFromBox!.accessToken;

  Future<int> extractIntClaim(String claim) async {
    return jwtDecode(token).payload[claim] as int;
  }

  Future<String> extractStringClaim(String claim) async {
    return jwtDecode(token).payload[claim] as String;
  }
}