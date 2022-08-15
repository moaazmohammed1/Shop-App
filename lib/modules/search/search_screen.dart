import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search/cubit/cubit.dart';
import 'package:shop_app/modules/search/cubit/states.dart';
import 'package:shop_app/shared/components.dart';

class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: buildTextFormField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    label: 'Search',
                    prefixIcon: Icons.search,
                    onFieldSubmittedFunction: (value) {
                      SearchCubit.get(context).search(text: value);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                if (state is SearchLoadingState)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: LinearProgressIndicator(),
                  ),
                const SizedBox(height: 10),
                if (state is SearchSuccessState)
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => myDivider(),
                      itemBuilder: (context, index) => buildListProduct(
                        SearchCubit.get(context).searchModel!.data!.data[index],
                        context,
                        isOldPrice: false,
                      ),
                      itemCount: SearchCubit.get(context)
                          .searchModel!
                          .data!
                          .data
                          .length,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
