import 'package:sixam_mart_store/util/images.dart';
import 'package:flutter/cupertino.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? placeholder;
  final bool isNotification;
  CustomImage(
      {required this.image,
      this.height,
      this.width,
      this.fit,
      this.placeholder,
      this.isNotification = false});

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder:
          isNotification ? Images.notification_placeholder : Images.placeholder,
      height: height,
      width: width,
      fit: fit,
      image: image,
      imageErrorBuilder: (c, o, s) => Image.asset(
        placeholder != null
            ? placeholder ?? ''
            : (isNotification)
                ? Images.notification_placeholder
                : Images.placeholder,
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }
}
