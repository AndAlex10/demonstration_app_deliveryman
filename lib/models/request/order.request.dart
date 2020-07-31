
class OrderRequest {
  String orderId;
  String orderCode;
  String idEstablishment;
  String action;
  String idDeliveryMan;

  OrderRequest.from(this.orderId, this.orderCode, this.idEstablishment, this.action, this.idDeliveryMan);

  Map<String, dynamic> toMap() {
    return {
      "orderId": this.orderId,
      "orderCode": this.orderCode,
      "idEstablishment": this.idEstablishment,
      "action": this.action,
      "idDeliveryMan": this.idDeliveryMan
    };
  }
}