import 'package:flutter/material.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/shared_widgets/ring_background.dart';

import '../../images.dart';

part 'widgets/progress_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> _images = [
    AppImage.animatedShopping,
    AppImage.animatedMarketPlace,
    AppImage.animatedBuy
  ];

  final List<String> _titleTexts = [
    "Looking for Great Deals on Products?",
    "Got Something You Want to Sell?",
    "Get Personalized Experience on Purchase",
  ];

  final List<String> _subtitleTexts = [
    "Unlock endless deals and unique finds—right at your fingertips.",
    "Share your items with thousands of buyers in just a few taps upload photos, set your price, and start earning!",
    "Buy and sell with confidence. Our secure payment system protects both buyers and sellers every step of the way."
  ];

  int _activeIndex = 0;

  final PageController _imageScrollController = PageController(initialPage: 0);
  final PageController _titleScrollController = PageController(initialPage: 0);
  final PageController _subtitleScrollController =
      PageController(initialPage: 0);

  @override
  void dispose() {
    _imageScrollController.dispose();
    _titleScrollController.dispose();
    _subtitleScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RingBackground(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 70, 18, 25),
        child: Column(
          children: [
            // logo and skip button
            Row(
              children: [
                Expanded(child: Center(child: Image.asset(AppImage.kuduLogo))),
                const Text("Skip",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 108),
            // scrollable-paged-images
            SizedBox(
              height: 274,
              width: double.infinity,
              child: PageView.builder(
                controller: _imageScrollController,
                itemCount: _images.length,
                onPageChanged: _setNewIndex,
                itemBuilder: (_, index) => Image.asset(_images[index],
                    height: 274, width: 274, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 77),
            _ProgressIndicator(activeIndex: _activeIndex),
            const SizedBox(height: 40),

            // title
            SizedBox(
              height: 90,
              width: double.infinity,
              child: PageView.builder(
                itemCount: _titleTexts.length,
                controller: _titleScrollController,
                onPageChanged: _setNewIndex,
                itemBuilder: (_, index) => Text(
                  _titleTexts[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      height: 1.2, fontWeight: FontWeight.w700, fontSize: 35),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // subtitle
            SizedBox(
              height: 48,
              width: double.infinity,
              child: PageView.builder(
                itemCount: _subtitleTexts.length,
                controller: _subtitleScrollController,
                onPageChanged: _setNewIndex,
                itemBuilder: (_, index) => Text(
                  _subtitleTexts[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      height: 1.01,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF575757)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // next button
            ElevatedButton(onPressed: _next, child: const Text("Next"))
          ],
        ),
      ),
    );
  }

  _next() {
    if (_activeIndex == 2) {
      return;
    }

    setState(() => _activeIndex++);
    _imageScrollController.animateToPage(_activeIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);

    _titleScrollController.animateToPage(_activeIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);

    _subtitleScrollController.animateToPage(_activeIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  _setNewIndex(int value) {
    setState(() => _activeIndex = value);

    _imageScrollController.animateToPage(value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);

    _titleScrollController.animateToPage(value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);

    _subtitleScrollController.animateToPage(value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }
}
