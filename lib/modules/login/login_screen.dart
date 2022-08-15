import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components.dart';
import 'package:shop_app/shared/constant.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    navToRegisterScreen() {
      navigateTo(context, RegisterScreen());
    }

    return BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              if (state.loginModel!.status!) {
                CacheHelper.saveData(
                  key: 'token',
                  value: state.loginModel!.data!.token,
                ).then((value) {
                  token = state.loginModel!.data!.token;
                  pushAndRemove(context, ShopLayout());
                });
                showToast(
                  message: state.loginModel!.message!,
                  state: ToastType.SUCCESS,
                );
              } else {
                showToast(
                  message: state.loginModel!.message!,
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
                            'Login',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.black),
                          ),
                          Text(
                            'Login now to browse our hot offers',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    fontSize: pixel_10 * 1.8,
                                    color: Colors.grey),
                          ),
                          const SizedBox(height: pixel_20 * 1.4),
                          buildTextFormField(
                            label: 'Email Address',
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            prefixIcon: Icons.email_outlined,
                            validateFunction: (value) {
                              if (value!.isEmpty)
                                return 'Place enter your email';
                            },
                          ),
                          const SizedBox(height: pixel_10 * 1.5),
                          buildTextFormField(
                            label: 'Password',
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: LoginCubit.get(context).suffix,
                            onFieldSubmittedFunction: (value) {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            functionSuffix: () {
                              LoginCubit.get(context)
                                  .changeSuffixIconPassword();
                            },
                            obscureText: LoginCubit.get(context).obScure,
                            validateFunction: (value) {
                              if (value!.isEmpty) {
                                return 'Place enter your password';
                              }
                            },
                          ),
                          const SizedBox(height: pixel_20 * 1.4),
                          ConditionalBuilder(
                              condition: state is! LoginLoadingState,
                              builder: (context) => buildButton(
                                  text: 'Login',
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      LoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  }),
                              fallback: (context) => const Center(
                                  child: CircularProgressIndicator())),
                          const SizedBox(height: pixel_20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Don\'t have an account?'),
                              buildTextButton(
                                  text: 'register',
                                  function: () {
                                    // pushAndRemove(context, RegisterScreen());
                                    // navigateTo(context, RegisterScreen());
                                    navToRegisterScreen();
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
        ));
  }
}
