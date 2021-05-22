class Shop {
  final String wallet;
  final String name;
  final String imageUrl;
  final bool isOnline;
  String address;
  String phone;
  String email;
  String uid;
  String bio;
  String catergory;

  Map toJson() => {
        'wallet': wallet,
        'name': name,
        'imageUrl': imageUrl,
        'isOnline': isOnline,
        'address': address,
        'phone': phone,
        'email': email,
        'uid': uid,
        'bio': bio,
        'catergory': catergory,
      };

  Shop(this.wallet, this.name, this.imageUrl, this.isOnline, this.email,
      this.address, this.uid, this.phone, this.bio, this.catergory);

  factory Shop.fromJson(dynamic json) {
    return Shop(
      json['wallet'] as String,
      json['name'] as String,
      json['imageUrl'] as String,
      json['isOnline'] as bool,
      json['address'] as String,
      json['phone'] as String,
      json['email'] as String,
      json['uid'] as String,
      json['bio'] as String,
      json['catergory'] as String,
    );
  }
}

// YOU - current user
