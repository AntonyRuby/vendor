import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/data/model/response/prediction_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController mapController;
  LocationSearchDialog({required this.mapController});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Container(
      margin: EdgeInsets.only(top: 0),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
        child: SizedBox(
            width: context.width,
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _controller,
                textInputAction: TextInputAction.search,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: 'search_location'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(style: BorderStyle.none, width: 0),
                  ),
                  hintStyle:
                      Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: Theme.of(context).disabledColor,
                          ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    ),
              ),
              suggestionsCallback: (pattern) async {
                return await Get.find<AuthController>()
                    .searchLocation(context, pattern);
              },
              itemBuilder: (context, PredictionModel suggestion) {
                return Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Row(children: [
                    Icon(Icons.location_on),
                    Expanded(
                      child: Text(suggestion.description ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                              )),
                    ),
                  ]),
                );
              },
              onSuggestionSelected: (PredictionModel suggestion) async {
                Position _position = await Get.find<AuthController>()
                    .setSuggestedLocation(suggestion.placeId ?? '',
                        suggestion.description ?? '', mapController);
                Get.back(result: _position);
              },
            )),
      ),
    );
  }
}
