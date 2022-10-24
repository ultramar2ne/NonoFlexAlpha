import 'package:flutter/cupertino.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';
import 'package:nonoflex_alpha/view/splash/splash_viewmodel.dart';

class SplashView extends BaseFormatView{
  SplashViewModel viewModel = SplashViewModel();

  @override
  drawBody(){
    return Center(
      child: Container(
        width: 60,
        height: 60,
        color: ColorName.primary,
      ),
    );
  }
}