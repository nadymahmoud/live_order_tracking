import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/routing/app_routes.dart';
import 'package:order_tracking_app/core/styling/app_colors.dart';
import 'package:order_tracking_app/core/widgets/loading_widget.dart';
import 'package:order_tracking_app/core/widgets/primay_button_widget.dart';
import 'package:order_tracking_app/core/widgets/spacing_widgets.dart';
import 'package:order_tracking_app/features/order_screen/cubit/order_cubit.dart';
import 'package:order_tracking_app/features/order_screen/cubit/order_state.dart';
import 'package:order_tracking_app/features/order_screen/model/order_model.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderCubit>(context).getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Order',
          style: TextStyle(color: Colors.white, fontSize: 27),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        leading: Container(),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is GettingOrderStatus) {
            return const LoadingWidget();
          }
          if (state is ErrorGettingOrder) {
            return Center(child: Text(state.message));
          }
          if (state is SuccessGettingOrder) {
            return Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () async {
                  BlocProvider.of<OrderCubit>(context).getOrders();
                },
                child: ListView.builder(
                  itemCount: state.orderList.length,
                  itemBuilder: (context, index) {
                    OrderModel orderModel = state.orderList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order Id: ${orderModel.orderId}"),
                              Text("Order Name: ${orderModel.orderName}"),
                              Text("Order Date: ${orderModel.orderDate}"),
                              Text("Order Status: ${orderModel.orderStatus}"),
                              HeightSpace(10),
                              PrimayButtonWidget(
                                onPress: () {
                                  context.pushNamed(
                                    AppRoutes.orderTtackMapScreen,
                                    extra: orderModel,
                                  );
                                },
                                buttonText: "Start Order",
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
