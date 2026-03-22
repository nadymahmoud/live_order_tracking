import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking_app/features/order_screen/cubit/order_state.dart';
import 'package:order_tracking_app/features/order_screen/model/order_model.dart';
import 'package:order_tracking_app/features/order_screen/repo/order_repo.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._orderRepo) : super(OrderInitial());
  final OrderRepo _orderRepo;

  Future<void> addOrder({required OrderModel orderModel}) async {
    emit(AddingOrderStatus());
    final result = await _orderRepo.addOrder(orderModel: orderModel);
    result.fold(
      (l) => emit(ErrorAddingOrder(l)),
      (r) => emit(SuccessAddingOrder(r)),
    );
  }

  Future<void> getOrders() async {
    emit(GettingOrderStatus());
    final result = await _orderRepo.getOrders();
    result.fold(
      (l) => emit(ErrorGettingOrder(l)),
      (r) => emit(SuccessGettingOrder(r)),
    );
  }

  Future<void> sendUserNewLocation({
    required String orderId,
    required double userLat,
    required double userLng,
  }) async {
    emit(GettingOrderStatus());
    await _orderRepo.editUserLocation(
      orderId: orderId,
      userLat: userLat,
      userLng: userLng,
    );
  }

  makeOrderDeliverd({required String orderId}) async {
    emit(GettingOrderStatus());
    final result = await _orderRepo.makeStatusDeliverd(orderId: orderId);
    return result.fold((l) {}, (r) => emit(OrderDeliverdStatus(r)));
  }

  getOrderById({required String orderId}) async {
    emit(GettingOrderStatus());
    final result = await _orderRepo.getOrderById(orderId: orderId);
    return result.fold((l) {
        emit( ErrorGettingOneOrder( l ));
    }, (r) => emit( SuccessGettingOneOrder(r)));
  }
}
