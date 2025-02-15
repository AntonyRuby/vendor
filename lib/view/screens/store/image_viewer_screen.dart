import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';

class ImageViewerScreen extends StatelessWidget {
  final Item item;
  ImageViewerScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    Get.find<StoreController>().setImageIndex(0, false);
    List<String> _imageList = [];
    _imageList.add(item.image ?? '');
    // _imageList.addAll(item.images ?? '');
    final PageController _pageController = PageController();

    return Scaffold(
      appBar: CustomAppBar(title: 'item_images'.tr),
      body: GetBuilder<StoreController>(builder: (storeController) {
        return Column(children: [
          Expanded(
              child: Stack(children: [
            PhotoViewGallery.builder(
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration:
                  BoxDecoration(color: Theme.of(context).cardColor),
              itemCount: _imageList.length,
              pageController: _pageController,
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(
                      '${Get.find<SplashController>().configModel.baseUrls?.itemImageUrl}/${_imageList[index]}'),
                  initialScale: PhotoViewComputedScale.contained,
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: index.toString()),
                );
              },
              loadingBuilder: (context, event) => Center(
                  child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                                (event.expectedTotalBytes ?? 0),
                      ))),
              onPageChanged: (int index) =>
                  storeController.setImageIndex(index, true),
            ),
            storeController.imageIndex != 0
                ? Positioned(
                    left: 5,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          if (storeController.imageIndex > 0) {
                            _pageController.animateToPage(
                              storeController.imageIndex - 1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Icon(Icons.chevron_left_outlined, size: 40),
                      ),
                    ),
                  )
                : SizedBox(),
            storeController.imageIndex != _imageList.length - 1
                ? Positioned(
                    right: 5,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          if (storeController.imageIndex < _imageList.length) {
                            _pageController.animateToPage(
                              storeController.imageIndex + 1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Icon(Icons.chevron_right_outlined, size: 40),
                      ),
                    ),
                  )
                : SizedBox(),
          ])),
        ]);
      }),
    );
  }
}
