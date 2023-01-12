import 'package:get/get.dart';

class Product {
  // 서버에서 관리되는 물품 고유 id : productId;
  final int productId;

  // 기관에서 관리하는 물품 고유 코드 : prdCode;
  final String productCode;

  // 상품 이름 : name
  final String prdName;

  // 상품 이미지 : image
  final ProductImage? imageData;

  // 상품 상세 설명 : description
  final String? description;

  // 분류 : category
  final ProductCategory category;

  // 제조사 : maker
  final String maker;

  // 규격 : unit
  final String unit;

  // 보관 방법 : storageType
  final StorageType storageType;

  // 물품 바코드 : barcode
  final String? barcode;

  // 물품 바코드 타입 : barcode type
  final String? barcodeType;

  // 재고 : stock
  final int stock;

  // 기준 가격 : price
  final double? price;

  // 마진율 : marign
  final double? marginPrice;

  // 물품 활성 여부 : active
  final bool isActive;

  Product(
      {required this.productId,
      required this.productCode,
      required this.prdName,
      required this.imageData,
      required this.description,
      required this.category,
      required this.maker,
      required this.unit,
      required this.storageType,
      required this.barcode,
      required this.barcodeType,
      required this.stock,
      required this.price,
      required this.marginPrice,
      required this.isActive});

  Product copyWith({
    String? productCode,
    String? prdName,
    ProductImage? imageData,
    String? description,
    ProductCategory? category,
    String? maker,
    String? unit,
    StorageType? storageType,
    String? barcode,
    String? barcodeType,
    int? stock,
    double? price,
    double? marginPrice,
    bool? isActive,
  }) {
    return Product(
      productId: productId,
      productCode: productCode ?? this.productCode,
      prdName: prdName ?? this.prdName,
      imageData: imageData,
      description: description ?? this.description,
      category: category ?? this.category,
      maker: maker ?? this.maker,
      unit: unit ?? this.unit,
      storageType: storageType ?? this.storageType,
      barcode: barcode ?? this.barcode,
      barcodeType: barcodeType ?? this.barcodeType,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      marginPrice: marginPrice ?? this.marginPrice,
      isActive: isActive ?? this.isActive,
    );
  }

  Product clearBarcode() {
    return Product(
      productId: productId,
      productCode: productCode,
      prdName: prdName,
      imageData: imageData,
      description: description,
      category: category,
      maker: maker,
      unit: unit,
      storageType: storageType,
      barcode: null,
      barcodeType: null,
      stock: stock,
      price: price,
      marginPrice: marginPrice,
      isActive: isActive,
    );
  }

  factory Product.fromJson(Map<String, dynamic> data) {
    final productId = data['productId'];
    final productCode = data['productCode'];
    final prdName = data['name'];
    final category = ProductCategory.getByServer(data['category']);
    final maker = data['maker'];
    final unit = data['unit'];
    final stock = data['stock']; // int
    final storageType = StorageType.getByServer(data['storageType']); // enum
    final isActive = data['active']; // bool

    // nullable
    final description = data['description'];
    final barcode = data['barcode'];
    final barcodeType = data['barcodeType'];
    final price = data['inputPrice'];
    final marginPrice = data['outputPrice'];
    final imageData = data['image'] != null && data['image']['imageId'] != null
        ? ProductImage.fromJson(data['image'])
        : null;

    return Product(
      productId: productId,
      productCode: productCode,
      prdName: prdName,
      category: category,
      maker: maker,
      unit: unit,
      stock: stock,
      storageType: storageType,
      isActive: isActive,
      description: description,
      barcode: barcode,
      barcodeType: barcodeType,
      price: price,
      marginPrice: marginPrice,
      imageData: imageData,
    );
  }

  Map<String, dynamic> toMap({bool forServer = true}) {
    Map<String, dynamic> data = {};

    data.addAll({
      'productId': productId,
      'productCode': productCode,
      'name': stock,
      'category': price,
      'maker': maker,
      'unit': unit,
      'stock': stock,
      'storageType': storageType.serverValue,
      'active': isActive,
    });

    data.addIf(description != null, 'description', description);
    data.addIf(barcode != null, 'barcode', barcode);
    data.addIf(barcodeType != null, 'barcodeType', barcodeType);
    data.addIf(price != null, 'inputPrice', price);
    data.addIf(marginPrice != null, 'outputPrice', marginPrice);
    data.addIf(imageData != null, 'image', imageData!.toMap());

    return data;
  }
}

class ProductImage {
  // file id : fileId
  final int imageId;

  // 원본 이미지 url : originalUrl
  final String imageUrl;

  // 용량이 적은 thumbnail 이미지 : thumbnailUrl
  final String thumbnailImageUrl;

  ProductImage({
    required this.imageId,
    required this.imageUrl,
    required this.thumbnailImageUrl,
  });

  factory ProductImage.fromJson(Map<String, dynamic> data) {
    final fileId = data['imageId'];
    final imageUrl = data['originalUrl'];
    final thumbnailImageUrl = data['thumbnailUrl'];

    return ProductImage(
      imageId: fileId,
      imageUrl: imageUrl,
      thumbnailImageUrl: thumbnailImageUrl,
    );
  }

  Map<String, dynamic> toMap({bool forServer = true}) {
    Map<String, dynamic> data = {};

    data.addAll({
      'imageId': imageId,
      'originalUrl': imageUrl,
      'thumbnailUrl': thumbnailImageUrl,
    });

    return data;
  }
}

enum ProductCategory {
  none('', ''),
  operation('operation', '운영물품'),
  food('food', '식재료'),
  hwaseong('hwaseong','화성용'),
  bonboo('bonboo','본부물품'),
  somo('소모품','소모품'),
  etc('etc', '기타');

  const ProductCategory(this.code, this.serverValue);

  final String code;
  final String serverValue;

  factory ProductCategory.getByServer(String serverValue) {
    return ProductCategory.values.firstWhere((value) => value.serverValue == serverValue,
        orElse: () => ProductCategory.none);
  }
}

extension ProductCategoryExt on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.none:
        return 'commonPlaceHolderSelect'.tr;
      case ProductCategory.operation:
        return 'productCategoryOperation'.tr;
      case ProductCategory.food:
        return 'productCategoryFood'.tr;
      case ProductCategory.etc:
        return 'productCategoryEtc'.tr;
      case ProductCategory.hwaseong:
        return '화성용';
      case ProductCategory.bonboo:
        return '본부물품';
      case ProductCategory.somo:
        return '소모품';
    }
  }
}

enum StorageType {
  none('', ''),
  ice('ice', 'ICE'),
  cold('cold', 'COLD'),
  room('room', 'ROOM');

  const StorageType(this.code, this.serverValue);

  final String code;
  final String serverValue;

  factory StorageType.getByServer(String serverValue) {
    return StorageType.values
        .firstWhere((value) => value.serverValue == serverValue, orElse: () => StorageType.room);
  }
}

extension StorageTypeExt on StorageType {
  String get displayName {
    switch (this) {
      case StorageType.ice:
        return 'productStorageTypeIce'.tr;
      case StorageType.cold:
        return 'productStorageTypeCold'.tr;
      case StorageType.room:
        return 'productStorageTypeRoom'.tr;
      case StorageType.none:
        return 'commonPlaceHolderSelect'.tr;
    }
  }
}

// class ProductDetail extends Product {
//   // product 목록에서 나타나는 데이터에 추가 데이터가 존재하지 않는가?
// }

class ProductList {
  // 현재 페이지 : page
  final int page;

  // : count
  final int count;

  // : totalPages
  final int totalPages;

  // : totalCount
  final int totalCount;

  // : lastPage
  final bool isLastPage;

  // 거래처 목록 : companyList
  final List<Product> items;

  ProductList(
      {required this.page,
      required this.count,
      required this.totalPages,
      required this.totalCount,
      required this.isLastPage,
      required this.items});

  factory ProductList.fromJson(Map<String, dynamic> data) {
    final metaData = data['meta'];
    final items = data['productList'];

    return ProductList(
        page: metaData['page'],
        count: metaData['count'],
        totalPages: metaData['totalPages'],
        totalCount: metaData['totalCount'],
        isLastPage: metaData['lastPage'],
        items: items.map<Product>((el) => Product.fromJson(el)).toList());
  }
}

enum ProductListSortType {
  productCode('', 'productCode'),
  name('', 'name'),
  stock('', 'stock'),
  price('', 'inputPrice'),
  marginPrice('', 'outputPrice');
  // category('','category'),
  // maker('','maker'),
  // storageType('','storageType'),
  // active('','');

  const ProductListSortType(this.code, this.serverValue);

  final String code;
  final String serverValue;

  factory ProductListSortType.fromServer(String serverValue) {
    return ProductListSortType.values.firstWhere((value) => value.serverValue == serverValue,
        orElse: () => ProductListSortType.name);
  }
}

extension ProductListSortTypeExt on ProductListSortType {
  String get displayName {
    switch (this) {
      case ProductListSortType.productCode:
        return '물품 코드';
      case ProductListSortType.name:
        return '물품 이름';
      case ProductListSortType.stock:
        return '현재 재고';
      case ProductListSortType.price:
        return '입고 금액';
      case ProductListSortType.marginPrice:
        return '출고 금액';
      // case ProductListSortType.category:
      //   return '물품 코드';
      // case ProductListSortType.maker:
      //   return '물품 코드';
      // case ProductListSortType.storageType:
      //   return '물품 코드';
      // case ProductListSortType.active:
      //   return '물품 코드';
    }
  }
}

/// 물품 정렬 기준 모음
/// 물품 정렬 기준을 로컬 저장할때 사용한다.
class ProductSortingSet {
  // 정렬 방향
  final bool isDesc;

  // 비활성 물품 노출 여부
  final bool onlyActive;

  // 목록 표현 방식
  final bool isGridLayout;

  // 정렬 기준
  final ProductListSortType sortType;

  ProductSortingSet({
    required this.isDesc,
    required this.onlyActive,
    required this.isGridLayout,
    required this.sortType,
  });

  ProductSortingSet copyWith({
    bool? isDesc,
    bool? onlyActive,
    bool? isGridLayout,
    ProductListSortType? sortType,
  }) {
    return ProductSortingSet(
      isDesc: isDesc ?? this.isDesc,
      onlyActive: onlyActive ?? this.onlyActive,
      isGridLayout: isGridLayout ?? this.isGridLayout,
      sortType: sortType ?? this.sortType,
    );
  }

  factory ProductSortingSet.fromMap(Map<dynamic, dynamic> data) {
    final isDesc = data['isDesc'] ?? false;
    final onlyActive = data['onlyActive'] ?? true;
    final isGridLayout = data['isGridLayout'] ?? false;
    final sortTypeValue = data['sortType'] ?? 'productCode';

    return ProductSortingSet(
      isDesc: isDesc,
      onlyActive: onlyActive,
      isGridLayout: isGridLayout,
      sortType: ProductListSortType.fromServer(sortTypeValue),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    data.addAll({
      'isDesc': isDesc,
      'onlyActive': onlyActive,
      'isGridLayout': isGridLayout,
      'sortType': sortType.serverValue,
    });

    return data;
  }
}
