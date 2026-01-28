import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'app_colors.dart';

class ToastHelper {
  static const _titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static const _messageStyle = TextStyle(
    fontSize: 13,
    color: Colors.white70,
    height: 1.2,
  );

  static void success(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    MotionToast(
      icon: Icons.check_circle_outline_rounded,
      primaryColor: AppColors.toastSuccess, // The Neon line/icon
      secondaryColor: AppColors.toastSuccessBg, // The Dark surface
      title: Text(title, style: _titleStyle),
      description: Text(message, style: _messageStyle),
      width: 320,
      height: 85,
      borderRadius: 12,
      animationType: AnimationType.slideInFromLeft,
      toastAlignment: Alignment.bottomLeft,
      dismissable: true,
      displayBorder: true,
      animationDuration: const Duration(milliseconds: 500),
      barrierColor: Colors.black.withOpacity(0.2),
    ).show(context);
  }

  static void error(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    MotionToast(
      icon: Icons.error_outline_rounded,
      primaryColor: AppColors.toastError, // The Neon Red line/icon
      secondaryColor: AppColors.toastErrorBg, // The Dark surface
      title: Text(title, style: _titleStyle),
      description: Text(message, style: _messageStyle),
      width: 320,
      height: 85,
      borderRadius: 12,
      animationType: AnimationType.slideInFromLeft,
      toastAlignment: Alignment.bottomLeft,
      dismissable: true,
      displayBorder: true,
      animationDuration: const Duration(milliseconds: 500),
      barrierColor: Colors.black.withOpacity(0.2),
    ).show(context);
  }
}
