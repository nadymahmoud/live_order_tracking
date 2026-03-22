import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/routing/app_routes.dart';
import 'package:order_tracking_app/core/styling/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white, fontSize: 27),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        leading: Container(),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.sp),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.sp,
            crossAxisSpacing: 8.sp,
          ),
          children: [
            InkWell(
              onTap: () {
                GoRouter.of(context).pushNamed(AppRoutes.orderScreen);
              },
              child: Container(
                margin: EdgeInsets.all(8.sp),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.primaryColor,
                ),
                child: Center(
                  child: Text(
                    'Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                GoRouter.of(context).pushNamed(AppRoutes.addOrderScreen);
              },
              child: Container(
                margin: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.primaryColor,
                ),
                child: Center(
                  child: Text(
                    'Add Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
