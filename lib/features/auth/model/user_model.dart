class UserModel {
  final String  username;
  final String  email;
  final String  uid;

  UserModel({  required  this.username, required this.email, required this.uid});
  factory UserModel.fromMap( Map<String, dynamic> map) {
    return UserModel(
      username: map['username'],
      email: map['email'],
      uid: map['uid'],
    );
  }
  Map < String, dynamic>toMap() {
    return {
      'username': username,
      'email': email,
      'uid': uid,
    };
  }
 }