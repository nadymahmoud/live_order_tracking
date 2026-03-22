import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_tracking_app/core/styling/app_assets.dart';
import 'package:order_tracking_app/core/styling/app_colors.dart';
import 'package:order_tracking_app/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking_app/core/utils/locations_services.dart';
import 'package:order_tracking_app/core/widgets/spacing_widgets.dart';
import 'package:order_tracking_app/features/order_screen/cubit/order_cubit.dart';
import 'package:order_tracking_app/features/order_screen/cubit/order_state.dart';
import 'package:order_tracking_app/features/order_screen/model/order_model.dart';

class UserTrackOrderMapScreen extends StatefulWidget {
  final OrderModel orderModel;
  const UserTrackOrderMapScreen({super.key, required this.orderModel});

  @override
  State<UserTrackOrderMapScreen> createState() => _UserTrackOrderMapScreenState();
}

class _UserTrackOrderMapScreenState extends State<UserTrackOrderMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  Set<Marker> markers = {};
  LatLng? currentUserLocation;

  final Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];

  loadOrderLocationAndUserMarker(OrderModel orderModel) async {
    final Uint8List markerIcon = await LocationsServices.getBytesFromAsset(
      AppAssets.order,
      50,
    );
    final Uint8List userMarkerIcon = await LocationsServices.getBytesFromAsset(
      AppAssets.truck,
      50,
    );

    final Marker marker = Marker(
      icon: BitmapDescriptor.bytes(markerIcon),
      markerId: MarkerId(orderModel.orderId.toString()),
      position: LatLng(
        orderModel.orderLat ?? 30.0596113,
        orderModel.orderLng ?? 31.1760626,
      ),
      onTap: () {
        customInfoWindowController.addInfoWindow!(
          Padding(
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
                  ],
                ),
              ),
            ),
          ),
          LatLng(
            orderModel.orderLat ?? 30.0596113,
            orderModel.orderLng ?? 31.1760626,
          ),
        );
      },
    );

    final Marker trackMarker = Marker(
      icon: BitmapDescriptor.bytes(userMarkerIcon),
      markerId: MarkerId(FirebaseAuth.instance.currentUser!.uid.toString()),
      position: LatLng(
        currentUserLocation?.latitude ?? 30.0596113,
        currentUserLocation?.longitude ?? 31.1760626,
      ),
      onTap: () {
        customInfoWindowController.addInfoWindow!(
          Padding(
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
                  ],
                ),
              ),
            ),
          ),
          LatLng(
            currentUserLocation?.latitude ?? 30.0596113,
            currentUserLocation?.longitude ?? 31.1760626,
          ),
        );
      },
    );

    markers.addAll([marker, trackMarker]);

    setState(() {});
  }

  getCurrentPositionAndAnimateToIT() async {
    try {
      Position position = await LocationsServices.determinePosition();
      currentUserLocation = LatLng(position.latitude, position.longitude);
      _animateToPosition(LatLng(position.latitude, position.longitude));
    } catch (e) {
      log(e.toString());
    }
  }

  listenToUserLocation() async {
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(distanceFilter: 10),
        ).listen((position) async {
          if (position != null) {
            currentUserLocation = LatLng(position.latitude, position.longitude);
            context.read<OrderCubit>().sendUserNewLocation(
              orderId: widget.orderModel.orderId.toString(),
              userLat: widget.orderModel.userLat!,
              userLng: widget.orderModel.userLng!,
            );
            checkDistanceBetweenTwoPoints(  
              LatLng(position.latitude, position.longitude),
              LatLng(widget.orderModel.orderLat!, widget.orderModel.orderLng!),);
          }
          ;
        });
  }

  Future<void> _animateToPosition(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 16),
      ),
    );
  }

  void _addPolyline() {
    _polylineCoordinates.add(
      LatLng(currentUserLocation!.latitude, currentUserLocation!.longitude),
    );
    _polylineCoordinates.add(
      LatLng(widget.orderModel.orderLat!, widget.orderModel.orderLng!),
    );

    PolylineId id = PolylineId("poly1");
    Polyline polyline = Polyline(
      polylineId: id,
      color: AppColors.primaryColor,
      points: _polylineCoordinates,
      width: 10,
      visible: true,
    );

    setState(() {
      _polylines.add(polyline);
    });
  }

  loadGetLocationThenLoadMarker() async {
    await getCurrentPositionAndAnimateToIT();

    _addPolyline();
    loadOrderLocationAndUserMarker(widget.orderModel);
  }

  checkDistanceBetweenTwoPoints(LatLng currentLocation, LatLng orderLocation) {
    double distanceInMeters = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      orderLocation.latitude,
      orderLocation.longitude,
    );
    if (distanceInMeters < 100) {
      context.read<OrderCubit>().makeOrderDeliverd(
        orderId: widget.orderModel.orderId.toString(),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadGetLocationThenLoadMarker();
    listenToUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderDeliverdStatus) {
            showAnimatedSnackDialog(
              context,
              message: state.message,
              type: AnimatedSnackBarType.success,
            );
            context.pop();
          }
        },
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.terrain,
              polylines: _polylines,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.orderModel.orderLat ?? 30.0596113,
                  widget.orderModel.orderLng ?? 31.1760626,
                ),
                zoom: 16,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                customInfoWindowController.googleMapController = controller;
              },
              onTap: (argument) {
                customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (position) {
                customInfoWindowController.onCameraMove!();
              },
              markers: markers,
            ),

            // CustomInfoWindow(
            CustomInfoWindow(
              controller: customInfoWindowController,
              height: 140.h,
              width: 200.w,
              offset: 50,
            ),
          ],
        ),
      ),
    );
  }
}
