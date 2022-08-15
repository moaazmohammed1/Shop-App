import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/constant.dart';
import 'package:shop_app/shared/cubit/cubit.dart';

navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

pushAndRemove(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (route) => true,
    );

signOut(context) => CacheHelper.removeData(
      key: 'token',
    ).then(
      (value) {
        if (value) {
          pushAndRemove(context, LoginScreen());
        }
      },
    );

Widget myDivider() => Container(
      height: 1,
      margin: EdgeInsets.only(left: 20.0),
      color: Colors.grey,
    );

Widget buildTextFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  bool obscureText = false,
  String? Function(String?)? validateFunction,
  Function(String)? onFieldSubmittedFunction,
  required String label,
  required IconData prefixIcon,
  IconData? suffixIcon,
  Function()? functionSuffix,
}) =>
    TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validateFunction,
      onFieldSubmitted: onFieldSubmittedFunction,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon:
            IconButton(onPressed: functionSuffix, icon: Icon(suffixIcon)),
        prefixIcon: Icon(prefixIcon),
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTextButton({required String text, Function()? function}) =>
    TextButton(
      onPressed: function,
      child:
          Text(text.toUpperCase(), style: const TextStyle(color: defaultColor)),
    );

Widget buildButton({required String text, Function()? function}) => Container(
      width: double.infinity,
      height: pixel_20 * 3,
      decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: BorderRadius.circular(pixel_10 / 2),
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
    );

showToast({required String message, required ToastType state}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastType { SUCCESS, ERROR, WARNING }

Color chooseColor(state) {
  Color? color;
  switch (state) {
    case ToastType.SUCCESS:
      color = Colors.green;
      break;
    case ToastType.ERROR:
      color = Colors.red;
      break;
    case ToastType.WARNING:
      color = Colors.amber;
      break;
  }
  return color!;
}



Widget buildListProduct(
  model,
  context, {
  bool isOldPrice = true,
}) =>
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120.0,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image!),
                  height: 120.0,
                  width: 120.0,
                ),
                if (model.discount != 0 && isOldPrice)
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        fontSize: 8.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          model.oldPrice.toString(),
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {

                          AppCubit.get(context).changeFavorite(model.id!);
                          // print(model.id);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                              AppCubit.get(context).favorites[model.id]!
                                  ? defaultColor
                                  : Colors.grey,
                          child: const Icon(
                            Icons.favorite_border,
                            size: 14.0,
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
      ),
    );
