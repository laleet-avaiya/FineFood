import 'User.dart';
import 'FoodProduct.dart';


class Order {
  User user;
  FoodProduct foodProduct;
  int quntity;
  int totalAmount;
  bool payment;
  String ordered_on = new DateTime.now().toIso8601String();

  Order(this.user, this.foodProduct, this.quntity, this.totalAmount,
      this.payment);

  toJson() {
    return {
      "user": user.toJson(),
      "foodProduct": foodProduct.toJson(),
      "quntity": quntity,
      "totalAmount": totalAmount,
      "payment": payment,
      "ordered_on": ordered_on
    };
  }
}
