import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/shared/components.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildCategoryItem(
                  AppCubit.get(context)
                      .categoriesModel!
                      .categoriesData!
                      .data[index]),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: AppCubit.get(context)
                  .categoriesModel!
                  .categoriesData!
                  .data
                  .length),
        );
      },
    );
  }

  Widget buildCategoryItem(DataModel data) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(data.image!),
              // image: AssetImage('assets/images/shop1.jpg'),
              width: 100.0,
              height: 100.0,
            ),
            const SizedBox(width: 15.0),
            Text(
              data.name!,
              style: const TextStyle(fontSize: 20.0),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      );
}
