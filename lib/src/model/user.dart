
import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id(assignable: true)
  int id;

  String username;
  String imageUrl;

  User({
    required this.id,
    required this.username,
    required this.imageUrl
  });

  toJson() => {
        'id': id,
        'username': username,
        'imageUrl': imageUrl,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      imageUrl: json['imageUrl'],
    );
  }
}
