import 'package:shop_app/models/change_favorites_model.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeNavBarItemState extends AppStates {}

class AppLoadingHomeDataState extends AppStates {}

class AppSuccessHomeDataState extends AppStates {}

class AppErrorHomeDataState extends AppStates {}

class AppSuccessCategoriesDataState extends AppStates {}

class AppErrorCategoriesDataState extends AppStates {}

class AppChangeFavoritesState extends AppStates {}

class AppSuccessChangeFavoritesState extends AppStates {
  final ChangeFavoritesModel changeFavoritesModel;

  AppSuccessChangeFavoritesState(this.changeFavoritesModel);
}

class AppErrorChangeFavoritesState extends AppStates {}

class AppLoadingGetFavoritesState extends AppStates {}

class AppSuccessGetFavoritesState extends AppStates {}

class AppErrorGetFavoritesState extends AppStates {}

class AppErrorChangeFavoritesFromHomeState extends AppStates {}


class AppSuccessGetFavoritesFromHomeState extends AppStates {}

class AppLoadingGetUserDataState extends AppStates {}

class AppSuccessGetUserDataState extends AppStates {}

class AppErrorGetUserDataState extends AppStates {}

class AppLoadingUpdateUserState extends AppStates {}

class AppSuccessUpdateUserState extends AppStates {}

class AppErrorUpdateUserState extends AppStates {}