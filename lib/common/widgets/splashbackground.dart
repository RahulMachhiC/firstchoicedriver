import 'package:first_choice_driver/common/app_image.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AppImage(
          "assets/background.png",
          fit: BoxFit.cover,
        ),
        Padding(
            padding: EdgeInsets.only(
              top: 170.h,
            ),
            child: Center(
              child: AppImage(
                "assets/logo.png",
                height: 170.h,
                width: 170.h,
                fit: BoxFit.contain,
              ).animate().fade(
                    duration: const Duration(milliseconds: 500),
                  ),
            ))
      ],
    );
  }
}
