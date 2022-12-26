import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as scanner;
import 'package:barcode_widget/barcode_widget.dart' as viewer;

enum ViewMode {
  add,
  edit,
}

class AddProductViewModel extends BaseController {
  ProductRepository _productRepository;

  ViewMode viewMode = ViewMode.add;

  // 수정 모드일 경우
  // int? productId;

  Product? currentProduct;

  // image
  final imagePath = ''.obs;
  ProductImage? networkImageInfo;

  // product Name
  final TextEditingController name = TextEditingController();
  final nameErrorMessage = ''.obs;

  // product description
  final TextEditingController description = TextEditingController();
  final descriptionErrorMessage = ''.obs;

  // product code
  final TextEditingController code = TextEditingController();
  final codeErrorMessage = ''.obs;

  // barcode
  final Rx<scanner.Barcode> barcode = scanner.Barcode(null, scanner.BarcodeFormat.qrcode, null).obs;

  // 물품 분류
  final Rx<ProductCategory> category = ProductCategory.none.obs;

  // 보관 방법
  final Rx<StorageType> storageType = StorageType.none.obs;

  // 규격
  final TextEditingController standard = TextEditingController();
  final standardErrorMessage = ''.obs;

  // 제조사
  final TextEditingController maker = TextEditingController();
  final makerErrorMessage = ''.obs;

  // 재고
  final TextEditingController stock = TextEditingController(text: '0');
  final stockErrorMessage = ''.obs;

  // 입고 가격
  final TextEditingController inputPrice = TextEditingController(text: '0');
  final inputPriceErrorMessage = ''.obs;

  // 출고 가격
  final TextEditingController outputPrice = TextEditingController(text: '0');
  final outputPriceErrorMessage = ''.obs;

  AddProductViewModel({int? productId, ProductRepository? productRepository})
      : _productRepository = productRepository ?? locator.get<ProductRepository>() {
    init(productId);
  }

  void init(int? productId) async {
    // 물품 id가 들어오는 경우 수정 모드로 변경
    if (productId != null) {
      viewMode = ViewMode.edit;
      update();

      try {
        currentProduct = await _productRepository.getProductDetailInfo(productId: productId);
        if (currentProduct != null) {
          networkImageInfo = currentProduct!.imageData;

          name.text = currentProduct!.prdName;
          code.text = currentProduct!.productCode;
          description.text = currentProduct!.description ?? '';
          if (currentProduct!.barcode != null && currentProduct!.barcode != '') {
            barcode.value =
                scanner.Barcode(currentProduct!.barcode!, scanner.BarcodeFormat.aztec, null);
          }
          category.value = currentProduct!.category;
          storageType.value = currentProduct!.storageType;
          standard.text = currentProduct!.unit;
          maker.text = currentProduct!.maker;
          stock.text = currentProduct!.stock.toString();
          inputPrice.text = currentProduct!.price?.toString() ?? '0';
          outputPrice.text = currentProduct!.marginPrice?.toString() ?? '0';
        }
        update();
      } catch (e) {
        logger.e(e);
      }
    }
  }

  void onClickedSaveButton() async {
    if (!await Get.alert('진짜 저장하시겠습니까?')) return;

    // 안되는 조건

    try {
      if (viewMode == ViewMode.add) {
        final product = Product(
          productId: 0,
          productCode: code.text,
          prdName: name.text,
          imageData: null,
          description: description.text,
          category: category.value,
          maker: maker.text,
          unit: standard.text,
          storageType: storageType.value,
          barcode: barcode.value.code,
          stock: int.tryParse(stock.value.text) ?? 0,
          price: int.tryParse(inputPrice.value.text),
          marginPrice: int.tryParse(outputPrice.value.text),
          isActive: true,
        );

        await _productRepository.addProduct(product);
      } else {
        final product = currentProduct!.copyWith(
          productCode: code.text,
          prdName: name.text,
          imageData: null,
          description: description.text,
          category: category.value,
          maker: maker.text,
          unit: standard.text,
          storageType: storageType.value,
          barcode: barcode.value.code,
          price: int.tryParse(inputPrice.value.text),
          marginPrice: int.tryParse(outputPrice.value.text),
          isActive: true,
        );

        await _productRepository.updateProductInfo(product);
      }
      Get.back();
    } catch (e) {
      logger.e(e);
    }
  }
}

extension updateField on AddProductViewModel {
  updateNameField(String value) {
    if (value.contains('ㅎ')) {
      // idError.value = '그러면 안돼요!';
      return;
    }
    // idError.value = '';
  }

  updateDescriptionField(String value) {
    if (value.contains('ㅎ')) {
      // idError.value = '그러면 안돼요!';
      return;
    }
    // idError.value = '';
  }

  updateCodeField(String value) {
    if (value.contains('ㅎ')) {
      // idError.value = '그러면 안돼요!';
      return;
    }
    // idError.value = '';
  }

  updateIdField(String value) {
    if (value.contains('ㅎ')) {
      // idError.value = '그러면 안돼요!';
      return;
    }
    // idError.value = '';
  }

  updateStandardField(String value) {
    if (value.contains('ㅎ')) {
      // idError.value = '그러면 안돼요!';
      return;
    }
    // idError.value = '';
  }

  updateMakerField(String value) {
    if (value.contains('ㅎ')) {
      // idError.value = '그러면 안돼요!';
      return;
    }
    // idError.value = '';
  }

  updateCategoryField(ProductCategory value) {
    if (value == category.value) return;
    category.value = value;
  }

  updateStorageTypeField(StorageType value) {
    if (value == storageType.value) return;
    storageType.value = value;
  }

  updateInputPriceField(String value) {
    if (value.contains('ㅎ')) {
      // idError.value = '그러면 안돼요!';
      return;
    }
    // idError.value = '';
  }

  updateOutputPriceField(String value) {
    if (value.contains('ㅎ')) {
      // idError.value = '그러면 안돼요!';
      return;
    }
    // idError.value = '';
  }
}

extension BarcodeExt on AddProductViewModel {
  viewer.Barcode? fromScanner(scanner.BarcodeFormat scannerformat) {
    switch (scannerformat) {
      case scanner.BarcodeFormat.aztec:
        return viewer.Barcode.aztec();
      case scanner.BarcodeFormat.codabar:
        return viewer.Barcode.codabar();
      case scanner.BarcodeFormat.code39:
        return viewer.Barcode.code39();
      case scanner.BarcodeFormat.code93:
        return viewer.Barcode.code93();
      case scanner.BarcodeFormat.code128:
        return viewer.Barcode.code128();
      case scanner.BarcodeFormat.dataMatrix:
        return viewer.Barcode.dataMatrix();
      case scanner.BarcodeFormat.ean8:
        return viewer.Barcode.ean8();
      case scanner.BarcodeFormat.ean13:
        return viewer.Barcode.ean13();
      case scanner.BarcodeFormat.itf:
        return viewer.Barcode.itf();
      case scanner.BarcodeFormat.pdf417:
        return viewer.Barcode.pdf417();
      case scanner.BarcodeFormat.qrcode:
        return viewer.Barcode.qrCode();
      case scanner.BarcodeFormat.upcA:
        return viewer.Barcode.upcA();
      case scanner.BarcodeFormat.upcE:
        return viewer.Barcode.upcE();
      case scanner.BarcodeFormat.upcEanExtension:
        return viewer.Barcode.upcE();

      case scanner.BarcodeFormat.maxicode:
      case scanner.BarcodeFormat.rss14:
      case scanner.BarcodeFormat.rssExpanded:
      case scanner.BarcodeFormat.unknown:
        return null;
    }
  }
}
