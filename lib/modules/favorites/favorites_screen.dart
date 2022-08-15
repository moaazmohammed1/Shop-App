import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: ConditionalBuilder(
            condition: state is! AppLoadingGetFavoritesState,
            builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) => myDivider(),
              itemBuilder: (context, index) => buildListProduct(
                  AppCubit.get(context).favoritesModel!.data!.data[index].product!,
                  context),
              itemCount:AppCubit.get(context).favoritesModel!.data!.data.length,
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
