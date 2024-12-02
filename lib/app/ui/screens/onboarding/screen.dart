import 'package:flutter/material.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/routes/routes.dart';

import '../../images.dart';

part 'widgets/background.dart';
part 'widgets/progress_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> _images = [
    AppUiImage.animatedShopping,
    AppUiImage.animatedMarketPlace,
    AppUiImage.animatedBuy
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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(18, 40, 18, 15),
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.95, -0.95),
            radius: 1.0,
            colors: [
              Color(0xFFD8E9F1),
              Color(0xFFF3EAE0),
              Color(0xFFF1F6F2),
              Color(0xFFF6F6F6),
            ],
            stops: [0.2289, 0.5027, 0.7268, 1.0],
          ),
        ),
        child: Column(
          children: [
            // logo and skip button
            Row(
              children: [
                Expanded(
                    child: Center(child: Image.asset(AppUiImage.kuduLogo))),
                GestureDetector(
                  onTap: () => const HomeScreenRoute().go(context),
                  child: const Text("Skip",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 55),
            // scrollable-paged-images
            Expanded(
              child: Stack(
                children: [
                  Center(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxWidth: 325, maxHeight: 325),
                          child: const _Rings())),
                  Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 274, maxHeight: 274),
                      child: PageView.builder(
                        controller: _imageScrollController,
                        itemCount: _images.length,
                        onPageChanged: (page) {
                          _setNewIndex(page);
                          _scrollTitleController(page);
                          _scrollSubtitleController(page);
                        },
                        itemBuilder: (_, index) =>
                            Image.asset(_images[index], fit: BoxFit.contain),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),
            _ProgressIndicator(activeIndex: _activeIndex),
            const SizedBox(height: 37),

            // title
            SizedBox(
              height: 100,
              width: double.infinity,
              child: PageView.builder(
                itemCount: _titleTexts.length,
                controller: _titleScrollController,
                onPageChanged: (page) {
                  _setNewIndex(page);
                  _scrollImageController(page);
                  _scrollSubtitleController(page);
                },
                itemBuilder: (_, index) => Text(
                  _titleTexts[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      height: 1.2, fontWeight: FontWeight.w600, fontSize: 29),
                ),
              ),
            ),

            // subtitle
            SizedBox(
              height: 48,
              width: double.infinity,
              child: PageView.builder(
                itemCount: _subtitleTexts.length,
                controller: _subtitleScrollController,
                onPageChanged: (page) {
                  _setNewIndex(page);
                  _scrollImageController(page);
                  _scrollTitleController(page);
                },
                itemBuilder: (_, index) => Text(
                  _subtitleTexts[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      height: 1.01,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Color(0xFF575757)),
                ),
              ),
            ),
            const SizedBox(height: 27),

            // explore as a guest button
            OutlinedButton(
                onPressed: () => const HomeScreenRoute().go(context),
                style: ButtonStyle(
                    foregroundColor:
                        const WidgetStatePropertyAll(AppUiColor.primary),
                    minimumSize: WidgetStateProperty.resolveWith<Size>(
                        (_) => const Size(double.infinity, 47))),
                child: const Text("Explore as Guest")),
            const SizedBox(height: 8),

            // next button
            ElevatedButton(
                onPressed: _next,
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.resolveWith<Size>(
                      (_) => const Size(double.infinity, 47)),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_activeIndex == 2 ? "Sign In" : "Next"),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Colors.white,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  _next() {
    if (_activeIndex == 2) {
      const SignInScreenRoute().push(context);
      return;
    }

    setState(() => _activeIndex++);
    _imageScrollController.animateToPage(_activeIndex,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);

    _titleScrollController.animateToPage(_activeIndex,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);

    _subtitleScrollController.animateToPage(_activeIndex,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  _setNewIndex(int value) {
    setState(() => _activeIndex = value);
  }

  _scrollTitleController(int page) {
    _titleScrollController.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  _scrollSubtitleController(int page) {
    _subtitleScrollController.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  _scrollImageController(int page) {
    _imageScrollController.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}
