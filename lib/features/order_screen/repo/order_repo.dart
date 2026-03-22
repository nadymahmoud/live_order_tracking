import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_tracking_app/features/order_screen/model/order_model.dart';

class OrderRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<Either<String, String>> addOrder({
    required OrderModel orderModel,
  }) async {
    try {
      await firestore.collection("orders").doc().set({
        "orderId": orderModel.orderId,
        "orderName": orderModel.orderName,
        "orderLat": orderModel.orderLat,
        "orderLng": orderModel.orderLng,
        "userLat": orderModel.userLat,
        "userLng": orderModel.userLng,
        "orderUserId": orderModel.orderUserId,
        "orderDate": orderModel.orderDate,
        "orderStatus": orderModel.orderStatus,
      });
      log("Order Added Successfully");
      return right("Order Added Successfully");
    } catch (e) {
      log("OrderFailed: ${e.toString()}");
      return left(" Error: ${e.toString()}");
    }
  }

  Future<Either<String, List<OrderModel>>> getOrders() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection("orders")
          .where(
            "orderUserId",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .get();
      List<OrderModel> orderList = [];
      for (var element in querySnapshot.docs) {
        orderList.add(OrderModel.fromJson(element.data()));
      }
      return right(orderList);
    } catch (e) {
      log("OrderFailed: ${e.toString()}");
      return left(" Error: ${e.toString()}");
    }
  }

  Future<Either<String, String>> editUserLocation({
    required String orderId,
    required double userLat,
    required double userLng,
  }) async {
    try {
      await firestore
          .collection("orders")
          .where("orderId", isEqualTo: orderId)
          .get()
          .then((value) async {
            value.docs.first.reference.update({
              "userLat": userLat,
              "userLng": userLng,
              "orderStatus": " on the way",
            });
          });
      return right("Order Status Updated Successfully");
    } catch (e) {
      log("OrderFailed: ${e.toString()}");
      return left(" Error: ${e.toString()}");
    }
  }


  Future<Either<String, String>> makeStatusDeliverd({
    required String orderId,
 
  }) async {
    try {
      await firestore
          .collection("orders")
          .where("orderId", isEqualTo: orderId)
          .get()
          .then((value) async {
            value.docs.first.reference.update({
             
              "orderStatus": "  Deliverd",
            });
          });
      return right("Order Status Updated Successfully");
    } catch (e) {
      log("OrderFailed: ${e.toString()}");
      return left(" Error: ${e.toString()}");
    }
  }

  Future <Either<String, OrderModel>> getOrderById({required String orderId})async{
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection("orders")
          .where(
            "orderId",
            isEqualTo: orderId,
          )
          .get();
      OrderModel orderModel = OrderModel.fromJson(querySnapshot.docs.first.data());
      return right(orderModel);
    } catch (e) {
      log("OrderFailed: ${e.toString()}");
      return left(" Error: ${e.toString()}");
    }
  }
}
