

enum StatusDelivery{
  AVAILABLE,
  PENDING,
  DELIVERY
}

class StatusDeliveryText{

  static String getTitle(int statusDelivery){
    if(statusDelivery == StatusDelivery.DELIVERY.index){
      return "Entregando";
    } else if (statusDelivery == StatusDelivery.PENDING.index){
      return "Pendente!";
    } else {
      return "";
    }
  }
}