import 'package:flutter/material.dart';
import 'package:news_website/Utils/AppColor.dart';

class ShowProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      child: LinearProgressIndicator(
        backgroundColor: AppColor.backGrey,
        valueColor: AppColor.app_color_animate,
      ),
    );
  }
}
