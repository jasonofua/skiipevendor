class Product {
  int id;
  String title, description;
  String images;
  double rating, price;
  bool isFavourite, isPopular;

  Product({
    this.id,
    this.images,
    this.rating,
    this.isFavourite,
    this.isPopular,
    this.title,
    this.price,
    this.description,
  });

  Product.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    images = json['images'];
    rating = json['rating'];
    isFavourite = json['isFavourite'];
    isPopular = json['isPopular'];
    title = json['title'];
    price = json['price'].toDouble();
    description = json['description'];
  }
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    images: "assets/images/ps4_console_white_1.png",
    title: "Wireless Controller for PS4™",
    price: 6400,
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: "assets/images/Image Popular Product 2.png",
    title: "Nike Sport White - Man Pant",
    price: 3500.5,
    description: description,
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: "assets/images/glap.png",
    title: "Gloves XC Omega - Polygon",
    price: 3600.00,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: "assets/images/wireless headset.png",
    title: "Logitech Head",
    price: 2000.00,
    description: description,
    rating: 4.1,
    isFavourite: true,
  ),
];

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
