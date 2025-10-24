import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/illustrations/learn.png",
      "title": "Learn at your pace",
      "text":
          "Access lessons anytime, anywhere — personalized just for your goals.",
    },
    {
      "image": "assets/illustrations/ai.png",
      "title": "AI-powered lessons",
      "text":
          "Experience adaptive learning powered by artificial intelligence for smarter progress.",
    },
    {
      "image": "assets/illustrations/progress.png",
      "title": "Track your progress",
      "text":
          "Monitor your learning journey with detailed analytics and daily goals.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3FDFD), Color(0xFFCBF1F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      isLastPage = index == onboardingData.length - 1;
                    });
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 40,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset(
                              data["image"]!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            data["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF112D4E),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            data["text"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF3F72AF),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Smooth page indicator
              SmoothPageIndicator(
                controller: _controller,
                count: onboardingData.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Color(0xFF3F72AF),
                  dotColor: Color(0xFFDDECFB),
                  dotHeight: 10,
                  dotWidth: 10,
                  expansionFactor: 3,
                  spacing: 6,
                ),
              ),
              const SizedBox(height: 40),

              // Get Started button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F72AF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  onPressed: () {
                    if (isLastPage) {
                      Navigator.pushReplacementNamed(context, AppRoutes.signup);
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    isLastPage ? "Get Started" : "Next",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
