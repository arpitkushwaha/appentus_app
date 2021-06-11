class User {
  int id;
  String name;
  String email;
  String password;
  String number;
  String image;

  User(
      {this.id, this.name, this.email, this.password, this.number, this.image});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    number = json['number'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['number'] = this.number;
    data['image'] = this.image;
    return data;
  }
}