class Auth {
  final String userPhoto;
  final String userName;
  final String userEmail;
  final String userId;

  Auth({this.userPhoto, this.userName, this.userEmail, this.userId});

  factory Auth.fromJSON(Map<String, dynamic> json) {
    return Auth(
        userPhoto: json["title"],
        userName: json["description"],
        userEmail: json["urlToImage"],
        userId: json["url"]);
  }
}
