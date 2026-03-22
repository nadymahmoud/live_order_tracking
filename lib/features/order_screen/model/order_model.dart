class OrderModel {
  String? orderId;
  String? orderName;
  double? orderLat;
  double? orderLng;
  double? userLat;
  double? userLng;
  String? orderUserId;
  String? orderDate;
  String? orderStatus;

  OrderModel({
    this.orderId,
    this.orderName,
    this.orderLat,
    this.orderLng,
    this.userLat,
    this.userLng,
    this.orderUserId,
    this.orderDate,
    this.orderStatus,
  });
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      orderName: json['orderName'],
      orderLat: json['orderLat'],
      orderLng: json['orderLng'],
      userLat: json['userLat'],
      userLng: json['userLng'],
      orderUserId: json['orderUserId'],
      orderDate: json['orderDate'],
      orderStatus: json['orderStatus'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderName': orderName,
      'orderLat': orderLat,
      'orderLng': orderLng,
      'userLat': userLat,
      'userLng': userLng,
      'orderUserId': orderUserId,
      'orderDate': orderDate,
      'orderStatus': orderStatus,
    };
  }
}
