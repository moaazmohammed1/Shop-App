import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components.dart';
import 'package:shop_app/shared/constant.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingModel {
  String? image;
  String? title;
  String? body;

  OnBoardingModel({this.image, this.title, this.body});
}

List<OnBoardingModel> boarding = [
  OnBoardingModel(
    image: 'assets/images/shop1.jpg',
    title: 'On Boarding Title 1',
    body: 'On Boarding Body 1',
  ),
  OnBoardingModel(
    image: 'assets/images/shop2.jpg',
    title: 'On Boarding Title 2',
    body: 'On Boarding Body 2',
  ),
  OnBoardingModel(
    image: 'assets/images/shop3.jpg',
    title: 'On Boarding Title 3',
    body: 'On Boarding Body 3',
  ),
];

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var pageController = PageController();

  bool isLast = false;

  skipOnBoarding() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        pushAndRemove(
          context,
          LoginScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: skipOnBoarding,
            child: const Text('SKIP'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: pageController,
                  itemBuilder: (context, index) =>
                      buildOnBoardingItem(boarding[index]),
                  itemCount: boarding.length,
                  onPageChanged: (index) {
                    if (index == boarding.length - 1) {
                      isLast = true;
                    } else {
                      isLast = false;
                    }
                  }),
            ),
            const SizedBox(height: 70.0),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 12,
                    dotColor: Colors.grey,
                    activeDotColor: defaultColor,
                    spacing: 4,
                    expansionFactor: 3,
                  ),
                  count: boarding.length,
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      skipOnBoarding();
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.fastOutSlowIn,
                      );
                    }
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildOnBoardingItem(OnBoardingModel boardingModel) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150.0),
                  image: DecorationImage(
                    image: AssetImage(boardingModel.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          Text(
            boardingModel.title!,
            style: const TextStyle(fontSize: 24.0),
          ),
          const SizedBox(height: 20.0),
          Text(
            boardingModel.body!,
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      );
}
