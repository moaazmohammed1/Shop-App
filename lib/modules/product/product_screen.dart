import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/search/search_screen.dart';
import 'package:shop_app/shared/components.dart';
import 'package:shop_app/shared/constant.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppSuccessChangeFavoritesState) {
          if (!state.changeFavoritesModel.status!) {
            showToast(
              message: state.changeFavoritesModel.message!,
              state: ToastType.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: ConditionalBuilder(
            condition: AppCubit.get(context).homeModel != null &&
                AppCubit.get(context).categoriesModel != null,
            builder: (context) => buildItem(AppCubit.get(context).homeModel!,
                AppCubit.get(context).categoriesModel!, context),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  buildItem(HomeModel model, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data!.banners
                  .map(
                    (e) => Image(
                      // image: //e.image != null?
                      image: NetworkImage(e.image!)
                      // : NetworkImage('https://via.placeholder.com/150'),
                      // image: AssetImage('assets/images/shop2.jpg'),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                viewportFraction: 1.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(height: 0.0),
                  Container(
                    height: 120.0,
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Stack(
                              alignment: AlignmentDirectional.bottomStart,
                              children: [
                                Image(
                                  width: 100.0,
                                  image: NetworkImage(categoriesModel
                                      .categoriesData!.data[index].image!),
                                  // image: AssetImage('assets/images/shop1.jpg'),
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.7),
                                  width: 100.0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Text(
                                    categoriesModel
                                        .categoriesData!.data[index].name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemCount: 5),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'New Product',
                    style: TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1.58,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  model.data!.products.length,
                  (index) =>
                      buildProductItem(model.data!.products[index], context),
                ),
              ),
            ),
          ],
        ),
      );

  buildProductItem(ProductsModel data, context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image(
            //   image: AssetImage(''),
            // ),
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Center(
                  child: Image(
                    height: 200.0,
                    image: NetworkImage(data.image!),
                    // image: AssetImage('assets/images/shop2.jpg'),
                  ),
                ),
                if (data.discount != 0)
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 7),
                  // Spacer(),
                  Row(
                    children: [
                      Text(
                        '${data.price}',
                        style: const TextStyle(
                          color: defaultColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (data.discount != 0)
                        Text(
                          '${data.oldPrice}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          AppCubit.get(context).changeFavorite(data.id!);
                          print(data.id);
                        },
                        icon: CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              AppCubit.get(context).favorites[data.id]!
                                  ? defaultColor
                                  : Colors.grey,
                          child: const Icon(
                            Icons.favorite_outline,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
