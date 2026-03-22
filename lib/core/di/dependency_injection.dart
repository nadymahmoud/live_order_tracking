import 'package:get_it/get_it.dart';
import 'package:order_tracking_app/features/auth/cubit/auth_cubit.dart';
import 'package:order_tracking_app/features/auth/repo/auth_repo.dart';
import 'package:order_tracking_app/features/order_screen/cubit/order_cubit.dart';
import 'package:order_tracking_app/features/order_screen/repo/order_repo.dart';

GetIt sl = GetIt.instance;

Future<void> initDI() async {
  sl.registerSingleton <AuthRepo>(AuthRepo());
  sl.registerLazySingleton( ()=>OrderRepo());
  sl.registerFactory( () => AuthCubit(sl<AuthRepo>()));
    sl.registerFactory( () => OrderCubit(sl< OrderRepo>()));

}
