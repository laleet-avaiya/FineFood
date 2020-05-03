class User {
  String name;
  String address;
  String phone;

  User(this.name, this.address, this.phone);

  toJson() {
    return {
      "name": name,
      "address": address,
      "phone": phone,
    };
  }
}

