import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_tracking_app/core/routing/app_routes.dart';
import 'package:order_tracking_app/core/styling/app_assets.dart';
import 'package:order_tracking_app/core/styling/app_styles.dart';
import 'package:order_tracking_app/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking_app/core/widgets/custom_text_field.dart';
import 'package:order_tracking_app/core/widgets/loading_widget.dart';
import 'package:order_tracking_app/core/widgets/primay_button_widget.dart';
import 'package:order_tracking_app/core/widgets/spacing_widgets.dart';
import 'package:order_tracking_app/features/auth/cubit/auth_cubit.dart';
import 'package:order_tracking_app/features/order_screen/cubit/order_cubit.dart';
import 'package:order_tracking_app/features/order_screen/cubit/order_state.dart';
import 'package:order_tracking_app/features/order_screen/model/order_model.dart';

/* 

 
   */
class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController orderIDController = TextEditingController();
  final TextEditingController orderNameController = TextEditingController();
  final TextEditingController orderArrivalDateController =
      TextEditingController();
  LatLng? orderLocation;
  LatLng? userLocation;
  DateTime? orderArrivalDate;
  String orderLocationDetails = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is SuccessAddingOrder) {
              showAnimatedSnackDialog(
                context,
                message: state.message,
                type: AnimatedSnackBarType.success,
              );
              orderIDController.clear();
              orderNameController.clear();
              orderArrivalDateController.clear();
              orderLocation = null;
              userLocation = null;
              orderArrivalDate = null;
              orderLocationDetails = "";
            }
            if (state is ErrorAddingOrder) {
              showAnimatedSnackDialog(
                context,
                message: state.message,
                type: AnimatedSnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            if (state is AddingOrderStatus) {
              return const LoadingWidget();
            }
            return Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(28),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "Create Your New Order",
                        style: AppStyles.primaryHeadLinesStyle,
                      ),
                    ),
                    const HeightSpace(8),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "Let’s create your  order.",
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
                      controller: orderIDController,
                      hintText: "Enter Your Order ID",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Order ID";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(8),
                    Text("Order Name", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      controller: orderNameController,
                      hintText: "Enter Your Order Name",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Order Name";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(8),
                    Text("Arrival  Date", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      readOnly: true,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050),
                        ).then((value) {
                          setState(() {
                            orderArrivalDate = value;
                            orderArrivalDateController.text =
                                "${orderArrivalDate!.day}/${orderArrivalDate!.month}/${orderArrivalDate!.year}";
                          });
                        });
                      },
                      controller: orderArrivalDateController,
                      hintText: "Enter Your Arrival Date",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Arrival Date";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(16),
                    PrimayButtonWidget(
                      buttonText: "Select Order Location",
                      onPress: () async {
                        LatLng? lating = await context.push<LatLng?>(
                          AppRoutes.placePickerScreen,
                        );
                        if (lating != null) {
                          orderLocation = lating;
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                lating.latitude,
                                lating.longitude,
                              );
                          orderLocationDetails =
                              "${placemarks.first.locality}, ${placemarks.first.country} ${placemarks.first.street}";
                          setState(() {});
                        }
                        log("lating : ${lating}");
                      },

                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                    const HeightSpace(8),

                    orderLocationDetails.isNotEmpty
                        ? Text(
                            " ${orderLocationDetails}",
                            style: AppStyles.black15BoldStyle,
                          )
                        : const SizedBox.shrink(),
                    const HeightSpace(30),
                    PrimayButtonWidget(
                      buttonText: "Create Order",
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          if (orderLocation == null) {
                            showAnimatedSnackDialog(
                              context,
                              message: "Please Select Order Location",
                              type: AnimatedSnackBarType.warning,
                            );
                            return;
                          }
                          if (orderArrivalDate == null) {
                            showAnimatedSnackDialog(
                              context,
                              message: "Please Select Order Arrival Date",
                              type: AnimatedSnackBarType.warning,
                            );
                            return;
                          }
                          OrderModel orderModel = OrderModel(
                            orderId: orderIDController.text,
                            orderName: orderNameController.text,
                            orderLat: orderLocation!.latitude,
                            orderLng: orderLocation!.longitude,
                            userLat: 0,
                            userLng: 0,
                            orderUserId: FirebaseAuth.instance.currentUser!.uid,
                            orderDate: orderArrivalDateController.text,
                            orderStatus: "Pending",
                          );
                          context.read<OrderCubit>().addOrder(
                            orderModel: orderModel,
                          );
                        }
                      },
                    ),
                    const HeightSpace(8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
