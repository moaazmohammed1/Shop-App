import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/register/cubit/cubit.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components.dart';
import 'package:shop_app/shared/constant.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.registerModel!.status!) {
              CacheHelper.saveData(
                key: 'token',
                value: state.registerModel!.data!.token,
              ).then((value) {
                token = state.registerModel!.data!.token;
                pushAndRemove(context, ShopLayout());
              });
              showToast(
                message: state.registerModel!.message!,
                state: ToastType.SUCCESS,
              );
            } else {
              showToast(
                message: state.registerModel!.message!,
                state: ToastType.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(pixel_20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  fontSize: pixel_10 * 1.8, color: Colors.grey),
                        ),
                        const SizedBox(height: pixel_20 * 1.4),
                        buildTextFormField(
                          label: 'Enter Name',
                          keyboardType: TextInputType.text,
                          controller: nameController,
                          prefixIcon: Icons.person,
                          validateFunction: (value) {
                            if (value!.isEmpty) {return 'Place enter your name';} return null;
                          },
                        ),
                        const SizedBox(height: pixel_10 * 1.5),
                        buildTextFormField(
                          label: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          prefixIcon: Icons.email_outlined,
                          validateFunction: (value) {
                            if (value!.isEmpty) {return 'Place enter your email';} return null;
                          },
                        ),
                        const SizedBox(height: pixel_10 * 1.5),
                        buildTextFormField(
                          label: 'Password',
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: RegisterCubit.get(context).suffix,
                          onFieldSubmittedFunction: (value) {
                            // if (formKey.currentState!.validate()) {
                            //   LoginCubit.get(context).userLogin(
                            //     email: emailController.text,
                            //     password: passwordController.text,
                            //   );
                            // }
                          },
                          functionSuffix: () {
                            RegisterCubit.get(context)
                                .changeSuffixIconPassword();
                          },
                          obscureText: RegisterCubit.get(context).obScure,
                          validateFunction: (value) {
                            if (value!.isEmpty) {
                              return 'Place enter your password';
                            } return null;
                          },
                        ),
                        const SizedBox(height: pixel_20 * 1.4),
                        buildTextFormField(
                            label: 'Enter phone',
                            keyboardType: TextInputType.number,
                            controller: phoneController,
                            prefixIcon: Icons.phone,
                            validateFunction: (value) {
                              if (value!.isEmpty) {
                                return 'Place enter your phone';
                              }
                              return null;
                            }),
                        const SizedBox(height: pixel_20 * 1.4),
                        ConditionalBuilder(
                            condition: state is! RegisterLoadingState,
                            builder: (context) => buildButton(
                                text: 'Register',
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    RegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                }),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator())),
                        const SizedBox(height: pixel_20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('you want login?'),
                            buildTextButton(
                                text: 'login',
                                function: () {
                                  pushAndRemove(context, LoginScreen());
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
