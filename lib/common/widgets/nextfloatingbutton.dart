import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/material.dart';

import '../../helpers/colors.dart';
import '../../helpers/text_style.dart';

class NextFloatingButton extends StatelessWidget {
  const NextFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.h,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.green,
              AppColors.yellow,
            ],
          ),
          borderRadius: BorderRadius.circular(40)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Next",
              style: AppText.text18w400.copyWith(
                color: Colors.white,
              )),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.arrow_forward_sharp,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
