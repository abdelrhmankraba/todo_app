import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/network/local/cache_helper.dart';
import 'states_mode.dart';

class AppCubitMode extends Cubit<AppStateMode> {
  AppCubitMode() : super(AppInitialStateMode());

  static AppCubitMode get(context) => BlocProvider.of(context);
  //Dark Mode
  bool isDark = false;
  void changeAppMode({bool? fromShared}){
    if(fromShared !=null)
    {
      isDark =fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }
}
