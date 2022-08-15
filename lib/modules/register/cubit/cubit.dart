import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/network/end_point.dart';
import 'package:shop_app/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  LoginModel? registerModel;
  userRegister(
      {required String name,
      required String email,
      required String password,
      required String phone}) {
    emit(RegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      dataFromUser: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      registerModel = LoginModel.fromJson(value.data);
      print('in register: ${registerModel!.message}');
      emit(RegisterSuccessState(registerModel));
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool obScure = true;

  changeSuffixIconPassword() {
    obScure = !obScure;
    suffix =
        obScure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangeSuffixIconPasswordState());
  }
}
