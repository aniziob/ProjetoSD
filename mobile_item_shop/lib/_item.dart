class Item {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imageLink;
  final bool isBuyed;
  final int quantityPurchased;

  const Item({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageLink,
    required this.isBuyed,
    required this.quantityPurchased,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      imageLink: json['img_link'],
      isBuyed: json['is_buyed'],
      quantityPurchased: json['quantity_purchased'],
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Item && id == other.id;
  }

  @override
  int get hashCode => id;
}

// ------------ //

class Itens {
  final List<int> ids;
  final List<String> names;
  final List<double> prices;
  final List<String> descriptions;
  final List<String> imageLinks;
  final List<bool> isBuyeds;
  final List<int> quantityPurchaseds;

  const Itens({
    required this.ids,
    required this.names,
    required this.prices,
    required this.descriptions,
    required this.imageLinks,
    required this.isBuyeds,
    required this.quantityPurchaseds,
  });

  factory Itens.fromJson(Map<String, dynamic> json) {
    return Itens(
      ids: json['id'].cast<int>(),
      names: json['name'].cast<String>(),
      prices: json['price'].cast<double>(),
      descriptions: json['description'].cast<String>(),
      imageLinks: json['img_link'].cast<String>(),
      isBuyeds: json['is_buyed'].cast<bool>(),
      quantityPurchaseds: json['quantity_purchased'].cast<int>(),
    );
  }
}
