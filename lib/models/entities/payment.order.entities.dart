
class PaymentOrder{
  String title;
  String cardNumber;
  String method;
  String image;
  bool inDelivery;
  String customerName;
  String token;
  String brand;
  String securityCode;
  String paymentId;
  String authorizationCode;

  PaymentOrder.fromMap(Map data){
    title = data['title'];
    method = data['method'];
    cardNumber = data['cardNumber'];
    inDelivery = data['inDelivery'];
    paymentId = data['paymentId'];
    image = data['image'];
  }

}