

class FoodProduct {
  String key;
  String name;
  String tag;
  String price;

  FoodProduct(this.name, this.tag, this.price);

//  FoodProduct.fromSnapshot(DataSnapshot snapshot) :
//        key = snapshot.key,
//        name = snapshot.value["name"],
//        tag = snapshot.value["tag"],
//        price = snapshot.value["price"];

  toJson() {
    return {
      "name": name,
      "tag": tag,
      "price": price,
    };
  }
}
