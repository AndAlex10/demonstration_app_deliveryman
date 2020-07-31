
enum StatusOrder {
  PENDING,
  IN_PRODUCTION,
  READY_FOR_DELIVERY,
  DELIVERY_ARRIVED_ESTABLISHMENT,
  OUT_FOR_DELIVERY,
  DELIVERY_ARRIVED_CLIENT,
  CONCLUDED,
  CANCELED
}

class StatusOrderText {

  static String getTitle(StatusOrder status){
    switch (status){
      case StatusOrder.PENDING: {
        return "PENDENTE";
      }
      case StatusOrder.IN_PRODUCTION: {
        return "EM PRODUÇÃO";
      }
      case StatusOrder.DELIVERY_ARRIVED_ESTABLISHMENT: {
        return "ENTREGADOR CHEGOU NO ESTABELECIMENTO";
      }
      case StatusOrder.READY_FOR_DELIVERY: {
        return "PRONTO PARA ENTREGA";
      }
      case StatusOrder.OUT_FOR_DELIVERY: {
        return "SAIU PARA ENTREGA";
      }
      case StatusOrder.DELIVERY_ARRIVED_CLIENT: {
        return "ENTREGADOR CHEGOU NO CLIENTE";
      }
      case StatusOrder.CONCLUDED: {
        return "ENTREGA REALIZADA";
      }
      case StatusOrder.CANCELED: {
        return "CANCELADO";
      }
      default: {
        return "NOT FOUND";
      }

    }

  }

  static String getNextStatus(StatusOrder status){
    switch (status){
      case StatusOrder.READY_FOR_DELIVERY: {
        return "CHEGUEI NO ESTABELECIMENTO";
      }
      case StatusOrder.DELIVERY_ARRIVED_ESTABLISHMENT: {
        return "INICIAR ENTREGA";
      }
      case StatusOrder.OUT_FOR_DELIVERY: {
        return "CHEGUEI NO CLIENTE";
      }
      case StatusOrder.DELIVERY_ARRIVED_CLIENT: {
        return "ENTREGA REALIZADA";
      }
      default: {
        return "NOT FOUND";
      }

    }
  }

  static String getTitleNotify(StatusOrder status, String codeOrder){
    switch (status){
      case StatusOrder.DELIVERY_ARRIVED_ESTABLISHMENT: {
        return "Pedido $codeOrder. Entregador chegou";
      }
      case StatusOrder.OUT_FOR_DELIVERY: {
        return "Seu pedido $codeOrder Saiu para Entrega!";
      }
      case StatusOrder.DELIVERY_ARRIVED_CLIENT: {
        return "Seu Pedido $codeOrder chegou!";
      }
      case StatusOrder.CONCLUDED: {
        return "Seu Pedido $codeOrder foi Entregue.";
      }
      default: {
        return "NOT FOUND";
      }

    }

  }

  static String getSubjectNotify(StatusOrder status){
    switch (status){
      case StatusOrder.DELIVERY_ARRIVED_ESTABLISHMENT: {
        return "Entregador chegou no estabelecimento para recolher o pedido";
      }
      case StatusOrder.OUT_FOR_DELIVERY: {
        return "Seu pedido Saiu para Entrega!";
      }
      case StatusOrder.DELIVERY_ARRIVED_CLIENT: {
        return "Seu pedido chegou!";
      }
      case StatusOrder.CONCLUDED: {
        return "Pedido Entregue.";
      }
      default: {
        return "NOT FOUND";
      }

    }

  }


  static String getIdTopic(StatusOrder status, String idClient, String idEstablishment){
    switch (status){
      case StatusOrder.DELIVERY_ARRIVED_ESTABLISHMENT: {
        return idEstablishment;
      }
      case StatusOrder.OUT_FOR_DELIVERY: {
        return idClient;
      }
      case StatusOrder.DELIVERY_ARRIVED_CLIENT: {
        return idClient;
      }
      case StatusOrder.CONCLUDED: {
        return idClient;
      }
      default: {
        return "NOT FOUND";
      }

    }

  }

}