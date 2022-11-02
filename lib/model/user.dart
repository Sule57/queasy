class User {
  String username;
  String email;
  String hashPassword;
  String? firstName;
  String? lastName;
  String? profilePicture;
  String? bio;
  int? age;

  User({
    required this.username,
    required this.email,
    required this.hashPassword,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.bio,
    this.age,
  });

  //TODO methods for user data
}
