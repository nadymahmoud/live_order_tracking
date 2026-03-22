import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/routing/app_routes.dart';

import 'package:order_tracking_app/core/styling/app_assets.dart';
import 'package:order_tracking_app/core/styling/app_styles.dart';
import 'package:order_tracking_app/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking_app/core/widgets/custom_text_field.dart';
import 'package:order_tracking_app/core/widgets/loading_widget.dart';
import 'package:order_tracking_app/core/widgets/primay_button_widget.dart';
import 'package:order_tracking_app/core/widgets/spacing_widgets.dart';
import 'package:order_tracking_app/features/auth/cubit/auth_state.dart';
import 'package:order_tracking_app/features/order_screen/cubit/order_cubit.dart';
import 'package:order_tracking_app/features/order_screen/cubit/order_state.dart';

class SearchMyOrderScreen extends StatefulWidget {
  const SearchMyOrderScreen({super.key});

  @override
  State<SearchMyOrderScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SearchMyOrderScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController orderID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    orderID = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is ErrorGettingOneOrder) {
              showAnimatedSnackDialog(
                context,
                message: state.message,
                type: AnimatedSnackBarType.error,
              );
            }
            if (state is SuccessGettingOneOrder) {
              context.pushNamed(
                AppRoutes.orderTtackMapScreen,
                extra: state.orderModel,
              );
            }
          },
          builder: (context, state) {
            if (state is GettingOneOrderStatus) {
              return const LoadingWidget();
            }
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeightSpace(28),
                      SizedBox(
                        width: 335.w,
                        child: Text(
                          "Track My Order",
                          style: AppStyles.primaryHeadLinesStyle,
                        ),
                      ),
                      const HeightSpace(8),
                      SizedBox(
                        width: 335.w,
                        child: Text(
                          "it's great to see you again",
                          style: AppStyles.grey12MediumStyle,
                        ),
                      ),
                      const HeightSpace(20),
                      Center(
                        child: Image.asset(
                          AppAssets.order,
                          width: 190.w,
                          height: 190.w,
                        ),
                      ),
                      const HeightSpace(32),
                      Text("Order ID", style: AppStyles.black16w500Style),
                      const HeightSpace(8),
                      CustomTextField(
                        controller: orderID,
                        hintText: "Enter Your Order ID",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your  Order ID";
                          }
                          return null;
                        },
                      ),

                      const HeightSpace(55),
                      PrimayButtonWidget(
                        buttonText: "Search",
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<OrderCubit>(
                              context,
                            ).getOrderById(orderId: orderID.text);
                          }
                        },
                      ),
                      const HeightSpace(8),
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
}
