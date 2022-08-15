import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/product/product_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/network/end_point.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/constant.dart';
import 'package:shop_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    ProductScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingScreen(),
  ];

  int currentIndex = 0;

  changeNavBarItem(int index) {
    currentIndex = index;
    emit(AppChangeNavBarItemState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};
  getHomeData() {
    emit(AppLoadingHomeDataState());
    DioHelper.getData(url: HOME).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      // print(homeModel!.data!.products[0].inFavorites);
      homeModel!.data!.products.forEach((element) {
        favorites.addAll(
          {
            element.id!: element.inFavorites!,
          },
        );
        // print('in Favorites ${element.id} is : ${element.inFavorites}');
      });
      emit(AppSuccessHomeDataState());
      // print('favorites is: ${favorites.toString()}');
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;
  getCategoriesData() {
    DioHelper.getData(url: GET_CATEGORIES).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(AppSuccessCategoriesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorCategoriesDataState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;
  changeFavorite(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(AppChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      dataFromUser: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print('${changeFavoritesModel!.message}');
      print('${changeFavoritesModel!.status}');
      if (!favorites[productId]!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavoritesData();
      }
      emit(AppSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      print(error.toString());
      emit(AppErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;
  getFavoritesData() {
    emit(AppLoadingGetFavoritesState());
    DioHelper.getData(url: FAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      // print(value.data.toString());
      emit(AppSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorGetFavoritesState());
    });
  }

  LoginModel? userData;
  getUserData() {
    emit(AppLoadingGetUserDataState());
    DioHelper.getData(url: PROFILE, token: token).then((value) {
      userData = LoginModel.fromJson(value.data);
      print(userData!.data!.name);
      emit(AppSuccessGetUserDataState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorGetUserDataState());
    });
  }

  updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(AppLoadingUpdateUserState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      dataFromUser: {
        'name':name,
        'email':email,
        'phone':phone,
      },
    ).then((value) {
      userData = LoginModel.fromJson(value.data);
      // print(userData!.data!.name);
      emit(AppSuccessUpdateUserState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorUpdateUserState());
    });
  }
}
