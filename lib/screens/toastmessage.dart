import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class showingToastMessage {
  static void ErrorToast(String message, BuildContext context) {
    showToast(
      message,
      textStyle: const TextStyle(
          fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
      fullWidth: true,
      reverseAnimation: StyledToastAnimation.fade,
      toastHorizontalMargin: 15,
      borderRadius: BorderRadius.circular(0),
      backgroundColor: Colors.red,
      alignment: Alignment.bottomLeft,
      position: StyledToastPosition.top,
      animation: StyledToastAnimation.slideFromTopFade,
      animDuration: const Duration(milliseconds: 1000),
      duration: const Duration(seconds: 5),
      context: context,
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }

  static void customToast(String message, BuildContext context) {
    showToast(
      message,
      textStyle: const TextStyle(
          fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
      fullWidth: true,
      reverseAnimation: StyledToastAnimation.fade,
      toastHorizontalMargin: 15,
      borderRadius: BorderRadius.circular(0),
      backgroundColor: Colors.green,
      alignment: Alignment.bottomLeft,
      position: StyledToastPosition.top,
      animation: StyledToastAnimation.slideFromTopFade,
      animDuration: const Duration(milliseconds: 1000),
      duration: const Duration(seconds: 5),
      context: context,
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}
