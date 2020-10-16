import 'dart:convert';

class User {
  final String id;
  final String displayName;
  final String photoUrl;

  User({
    this.id,
    this.displayName,
    this.photoUrl,
  });

  @override
  String toString() {
    return '{"id":$id, "displayName":$displayName, "photoUrl":$photoUrl}';
  }

  User fromString(String str) {
    if (str == null || str.isEmpty) {
      return null;
    }
    try {
      final json = jsonDecode(str);
      return User(
        id: json.containsKey('id') ? json['id'] : null,
        displayName:
            json.containsKey('displayName') ? json['displayName'] : null,
        photoUrl: json.containsKey('photoUrl') ? json['photoUrl'] : null,
      );
    } catch (e) {
      return null;
    }
  }
}
