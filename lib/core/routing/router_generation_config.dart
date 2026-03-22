import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/di/dependency_injection.dart';
import 'package:order_tracking_app/core/routing/app_routes.dart';
import 'package:order_tracking_app/features/order_screen/cubit/order_cubit.dart';
import 'package:order_tracking_app/features/order_screen/model/order_model.dart';
import 'package:order_tracking_app/features/order_screen/my_order_screen.dart';
import 'package:order_tracking_app/features/order_screen/order_screen.dart';
import 'package:order_tracking_app/features/order_screen/order_track_map_screen.dart';
import 'package:order_tracking_app/features/order_screen/place_picker_screen.dart';
import 'package:order_tracking_app/features/auth/cubit/auth_cubit.dart';
import 'package:order_tracking_app/features/auth/login_screen.dart';
import 'package:order_tracking_app/features/auth/register_screen.dart';
import 'package:order_tracking_app/features/home/home_screen.dart';
import 'package:order_tracking_app/features/order_screen/search_my_order_screen.dart';
import 'package:order_tracking_app/features/order_screen/user_track_order_map_screen.dart';
import 'package:order_tracking_app/features/splash_screen/splash_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        name: AppRoutes.splashScreen,
        path: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.registerScreen,
        path: AppRoutes.registerScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.mainScreen,
        path: AppRoutes.mainScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: AppRoutes.addOrderScreen,
        path: AppRoutes.addOrderScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<OrderCubit>(),
          child: const AddOrderScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.orderScreen,
        path: AppRoutes.orderScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<OrderCubit>(),
          child: const MyOrderScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.orderTtackMapScreen,
        path: AppRoutes.orderTtackMapScreen,
        builder: (context, state) {
          OrderModel orderModel = state.extra as OrderModel;
          return BlocProvider(
            create: (context) => sl<OrderCubit>(),
            child:   OrderTrackMapScreen( orderModel: orderModel,),
          );
        },
      ),

        GoRoute(
        name: AppRoutes.trackMyOrderUserMap,
        path: AppRoutes.trackMyOrderUserMap,
        builder: (context, state) {
          OrderModel orderModel = state.extra as OrderModel;
          return BlocProvider(
            create: (context) => sl<OrderCubit>(),
            child:   UserTrackOrderMapScreen( orderModel: orderModel,),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.searchMyOrderScreen,
        path: AppRoutes.searchMyOrderScreen,
        builder: (context, state) {
   
          return BlocProvider(
            create: (context) => sl<OrderCubit>(),
            child:   SearchMyOrderScreen( ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.placePickerScreen,
        path: AppRoutes.placePickerScreen,
        builder: (context, state) => const PlacePickerScreen(),
      ),
    ],
  );
}
