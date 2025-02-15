import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/order_details_model.dart';
import 'package:sixam_mart_store/data/model/response/order_model.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderModel order;
  final OrderDetailsModel orderDetails;
  OrderItemWidget({required this.order, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    // print(
    //     '--------${'${order.itemCampaign == 1 ? Get.find<SplashController>().configModel.baseUrls?.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${orderDetails.itemDetails?.image}'}');
    String _addOnText = '';
    orderDetails.addOns?.forEach((addOn) {
      _addOnText = _addOnText +
          '${(_addOnText.isEmpty) ? '' : ',  '}${addOn.name} (${addOn.quantity})';
    });

    String _variationText = '';
    if ((orderDetails.variation?.length ?? 0) > 0) {
      List<String> _variationTypes =
          (orderDetails.variation?.first.type).toString().split('-');
      if (_variationTypes.length ==
          (orderDetails.itemDetails?.choiceOptions ?? []).length) {
        int _index = 0;
        (orderDetails.itemDetails?.choiceOptions ?? []).forEach((choice) {
          _variationText = _variationText +
              '${(_index == 0) ? '' : ',  '}${choice.title} - ${_variationTypes[_index]}';
          _index = _index + 1;
        });
      } else {
        _variationText =
            (orderDetails.itemDetails?.variations?.first.type).toString();
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          child: CustomImage(
            height: 50,
            width: 50,
            fit: BoxFit.cover,
            image:
                '${order.itemCampaign == 1 ? Get.find<SplashController>().configModel.baseUrls?.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls?.itemImageUrl}/${orderDetails.itemDetails?.image}',
          ),
        ),
        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Text(
                (orderDetails.itemDetails?.name).toString(),
                style:
                    robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
              Text('${'quantity'.tr}:',
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL)),
              Text(
                orderDetails.quantity.toString(),
                style: robotoMedium.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.FONT_SIZE_SMALL),
              ),
            ]),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Row(children: [
              Expanded(
                  child: Text(
                PriceConverter.convertPrice(orderDetails.price),
                style: robotoMedium,
              )),
              (((Get.find<SplashController>()
                                  .configModel
                                  .moduleConfig
                                  ?.module
                                  ?.unit ??
                              false) &&
                          orderDetails.itemDetails?.unitType != null) ||
                      ((Get.find<SplashController>()
                                  .configModel
                                  .moduleConfig
                                  ?.module
                                  ?.vegNonVeg ??
                              false) &&
                          (Get.find<SplashController>()
                                  .configModel
                                  .toggleVegNonVeg ??
                              false)))
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          horizontal: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        (Get.find<SplashController>()
                                    .configModel
                                    .moduleConfig
                                    ?.module
                                    ?.unit ??
                                false)
                            ? orderDetails.itemDetails?.unitType ?? ''
                            : orderDetails.itemDetails?.veg == 0
                                ? 'non_veg'.tr
                                : 'veg'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                            color: Colors.white),
                      ),
                    )
                  : SizedBox(),
            ]),
          ]),
        ),
      ]),
      _addOnText.isNotEmpty
          ? Padding(
              padding:
                  EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Row(children: [
                SizedBox(width: 60),
                Text('${'addons'.tr}: ',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL)),
                Flexible(
                    child: Text(_addOnText,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                          color: Theme.of(context).disabledColor,
                        ))),
              ]),
            )
          : SizedBox(),
      (orderDetails.itemDetails?.variations ?? []).length > 0
          ? Padding(
              padding:
                  EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Row(children: [
                SizedBox(width: 60),
                Text('${'variations'.tr}: ',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL)),
                Flexible(
                    child: Text(_variationText,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                          color: Theme.of(context).disabledColor,
                        ))),
              ]),
            )
          : SizedBox(),
      Divider(height: Dimensions.PADDING_SIZE_LARGE),
      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
    ]);
  }
}
