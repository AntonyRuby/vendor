import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String message, {bool isError = true}) {
  Get.showSnackbar(GetSnackBar(
    backgroundColor: isError ? Colors.red : Color(0xFFFF0092),
    message: message,
    duration: Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING,
    margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
    borderRadius: 10,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
  ));
}
// tryh okey done bro thank you no issue. takae care aand bye
