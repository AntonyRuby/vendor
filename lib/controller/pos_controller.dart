import 'package:sixam_mart_store/data/api/api_checker.dart';
import 'package:sixam_mart_store/data/model/response/cart_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/data/repository/pos_repo.dart';
import 'package:get/get.dart';

class PosController extends GetxController implements GetxService {
  final PosRepo posRepo;
  PosController({required this.posRepo});

  List<CartModel> _cartList = [];
  double _amount = 0.0;
  List<int> _variationIndex = [];
  int _quantity = 1;
  List<bool> _addOnActiveList = [];
  List<int> _addOnQtyList = [];
  double _discount = -1;
  double _tax = -1;

  List<CartModel> get cartList => _cartList;
  double get amount => _amount;
  List<int> get variationIndex => _variationIndex;
  int get quantity => _quantity;
  List<bool> get addOnActiveList => _addOnActiveList;
  List<int> get addOnQtyList => _addOnQtyList;
  double get discount => _discount;
  double get tax => _tax;

  Future<List<Item>> searchItem(String searchText) async {
    List<Item> _searchProductList = [];
    if (searchText.isNotEmpty) {
      Response response = await posRepo.searchItemList(searchText);
      if (response.statusCode == 200) {
        _searchProductList = [];
        response.body
            .forEach((item) => _searchProductList.add(Item.fromJson(item)));
      } else {
        ApiChecker.checkApi(response);
      }
    }
    return _searchProductList;
  }

  void addToCart(CartModel cartModel, int index) {
    _amount = _amount -
        ((_cartList[index].discountedPrice ?? 0) *
            (_cartList[index].quantity ?? 0));
    _cartList.replaceRange(index, index + 1, [cartModel]);
    _amount = _amount +
        ((cartModel.discountedPrice ?? 0) * (cartModel.quantity ?? 0));
    update();
  }

  void setQuantity(bool isIncrement, CartModel cart) {
    int index = _cartList.indexOf(cart);
    if (isIncrement) {
      _cartList[index].quantity = (_cartList[index].quantity ?? 0) + 1;
      _amount = _amount + (_cartList[index].discountedPrice ?? 0);
    } else {
      _cartList[index].quantity = (_cartList[index].quantity ?? 0) - 1;
      _amount = _amount - (_cartList[index].discountedPrice ?? 0);
    }
    update();
  }

  void removeFromCart(int index) {
    _amount = _amount -
        ((_cartList[index].discountedPrice ?? 0) *
            (_cartList[index].quantity ?? 0));
    _cartList.removeAt(index);
    update();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index].addOnIds?.removeAt(addOnIndex);
    update();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    update();
  }

  bool isExistInCart(CartModel cartModel, bool isUpdate, int cartIndex) {
    for (int index = 0; index < _cartList.length; index++) {
      if ((_cartList[index].item?.id ?? 0) == (cartModel.item?.id ?? 0) &&
          ((_cartList[index].variation?.length ?? 0) > 0
              ? (_cartList[index].variation?.first.type) ==
                  (cartModel.variation?.first.type)
              : true)) {
        if ((isUpdate && index == cartIndex)) {
          return false;
        } else {
          return true;
        }
      }
    }
    return false;
  }

  void initData(Item product, CartModel cart) {
    _variationIndex = [];
    _addOnQtyList = [];
    _addOnActiveList = [];
    _quantity = cart.quantity ?? 0;
    List<String> _variationTypes = [];
    if ((cart.variation?.length ?? 0) > 0 &&
        cart.variation?.first.type != null) {
      _variationTypes.addAll((cart.variation?.first.type ?? '').split('-'));
    }
    int _varIndex = 0;
    product.choiceOptions?.forEach((choiceOption) {
      for (int index = 0;
          index < (choiceOption.options?.length ?? 0);
          index++) {
        if ((choiceOption.options?[index] ?? '').trim().replaceAll(' ', '') ==
            _variationTypes[_varIndex].trim()) {
          _variationIndex.add(index);
          break;
        }
      }
      _varIndex++;
    });
    List<int> _addOnIdList = [];
    cart.addOnIds?.forEach((addOnId) => _addOnIdList.add(addOnId.id ?? 0));
    product.addOns?.forEach((addOn) {
      if (_addOnIdList.contains(addOn.id)) {
        _addOnActiveList.add(true);
        _addOnQtyList.add(
            cart.addOnIds?[_addOnIdList.indexOf(addOn.id ?? 0)].quantity ?? 0);
      } else {
        _addOnActiveList.add(false);
        _addOnQtyList.add(1);
      }
    });
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList[index] = _addOnQtyList[index] + 1;
    } else {
      _addOnQtyList[index] = _addOnQtyList[index] - 1;
    }
    update();
  }

  void setProductQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity + 1;
    } else {
      _quantity = _quantity - 1;
    }
    update();
  }

  void setCartVariationIndex(int index, int i) {
    _variationIndex[index] = i;
    update();
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    update();
  }

  void setDiscount(String discount) {
    try {
      _discount = double.parse(discount);
    } catch (e) {
      _discount = 0;
    }
    update();
  }

  void setTax(String tax) {
    try {
      _tax = double.parse(tax);
    } catch (e) {
      _tax = 0;
    }
    update();
  }
}
