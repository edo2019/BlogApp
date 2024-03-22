class user {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;

  user({
    this.id, 
    this.name, 
    this.image, 
    this.email, 
    this.token
    });

  //function to convert json data to user model
  factory user.fromJson(Map<String, dynamic> json) {
    return user(
      id: json['user']['id'],
      name: json['user']['name'],
      image: json['user']['image'],
      email: json['user']['email'],
      token: json['user']['token'],

    );
  }
}
