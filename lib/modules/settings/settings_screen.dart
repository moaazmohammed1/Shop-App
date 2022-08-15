import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components.dart';
import 'package:shop_app/shared/constant.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

class SettingScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        nameController.text = AppCubit.get(context).userData!.data!.name!;
        emailController.text = AppCubit.get(context).userData!.data!.email!;
        phoneController.text = AppCubit.get(context).userData!.data!.phone!;
        return ConditionalBuilder(
            condition: state is! AppLoadingGetUserDataState,
            builder: (context) => Scaffold(
                  body: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              if(state is AppLoadingUpdateUserState)
                              const LinearProgressIndicator(),
                              const SizedBox(height: pixel_10 * 1.5),
                              buildTextFormField(
                                label: 'Name',
                                keyboardType: TextInputType.text,
                                controller: nameController,
                                prefixIcon: Icons.person,
                                validateFunction: (value) {
                                  if (value!.isEmpty) {
                                    return 'Place enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: pixel_10 * 1.5),
                              buildTextFormField(
                                label: 'Email Address',
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                prefixIcon: Icons.email_outlined,
                                validateFunction: (value) {
                                  if (value!.isEmpty) {
                                    return 'Place enter your email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: pixel_10 * 1.5),
                              buildTextFormField(
                                label: 'Phone Number',
                                keyboardType: TextInputType.text,
                                controller: phoneController,
                                prefixIcon: Icons.phone,
                                validateFunction: (value) {
                                  if (value!.isEmpty) {
                                    return 'Place enter your phone number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: pixel_10 * 1.5),
                              buildButton(
                                  text: 'update',
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      AppCubit.get(context).updateUserData(
                                        name: nameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                      );
                                    }
                                  }),
                              const SizedBox(height: pixel_10 * 1.5),
                              buildButton(
                                  text: 'Sign Out',
                                  function: () {
                                    signOut(context);
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            fallback: (context) => const Center(
                  child: LinearProgressIndicator(),
                ));
      },
    );
  }
}
