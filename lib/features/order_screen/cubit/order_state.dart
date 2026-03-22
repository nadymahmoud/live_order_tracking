import 'package:order_tracking_app/features/order_screen/model/order_model.dart';

abstract  class OrderState {}

class OrderInitial extends OrderState {}

class AddingOrderStatus extends OrderState {}

class SuccessAddingOrder extends OrderState {
    final String message;
  SuccessAddingOrder(this.message);
}

class ErrorAddingOrder extends OrderState {
  final String message;
  ErrorAddingOrder(this.message);
}


class GettingOrderStatus extends OrderState {}

class SuccessGettingOrder extends OrderState {
    final List<OrderModel> orderList;
  SuccessGettingOrder(this.orderList);
}

class ErrorGettingOrder extends OrderState {
  final String message;
  ErrorGettingOrder(this.message);
}

class OrderDeliverdStatus extends OrderState {
  final String message;
  OrderDeliverdStatus(this.message);
}

class GettingOneOrderStatus extends OrderState {}

class SuccessGettingOneOrder extends OrderState {
  final OrderModel orderModel;
  SuccessGettingOneOrder(this.orderModel);
}

class ErrorGettingOneOrder extends OrderState {
  final String message;
  ErrorGettingOneOrder(this.message);
}
