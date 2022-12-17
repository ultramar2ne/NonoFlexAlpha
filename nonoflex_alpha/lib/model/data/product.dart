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
  final String category;

  // 제조사 : maker
  final String maker;

  // 규격 : unit
  final String unit;

  // 보관 방법 : storageType
  final StorageType storageType;

  // 물품 바코드 : barcode
  final String? barcode;

  // 재고 : stock
  final int stock;

  // 기준 가격 : price
  final int? price;

  // 마진율 : marign
  final int? marginPrice;

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
      required this.stock,
      required this.price,
      required this.marginPrice,
      required this.isActive});

  factory Product.fromJson(Map<String, dynamic> data) {
    final productId = data['productId'];
    final productCode = data['productCode'];
    final prdName = data['name'];
    final category = data['category'];
    final maker = data['maker'];
    final unit = data['unit'];
    final stock = data['stock']; // int
    final storageType = StorageType.getByServer(data['storageType']); // enum
    final isActive = data['active']; // bool

    // nullable
    final description = data['description'];
    final barcode = data['barcode'];
    final price = data['price'];
    final marginPrice = data['margin'];
    final imageData = data['image'] != null && data['image']['fileId'] != null
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
    data.addIf(price != null, 'price', price);
    data.addIf(marginPrice != null, 'margin', marginPrice);
    data.addIf(imageData != null, 'image', imageData!.toMap());

    return data;
  }
}

class ProductImage {
  // file id : fileId
  final int fileId;

  // 원본 이미지 url : originalUrl
  final String imageUrl;

  // 용량이 적은 thumbnail 이미지 : thumbnailUrl
  final String thumbnailImageUrl;

  ProductImage({
    required this.fileId,
    required this.imageUrl,
    required this.thumbnailImageUrl,
  });

  factory ProductImage.fromJson(Map<String, dynamic> data) {
    final fileId = data['fileId'];
    final imageUrl = data['originalUrl'];
    final thumbnailImageUrl = data['thumbnailUrl'];

    return ProductImage(
      fileId: fileId,
      imageUrl: imageUrl,
      thumbnailImageUrl: thumbnailImageUrl,
    );
  }

  Map<String, dynamic> toMap({bool forServer = true}) {
    Map<String, dynamic> data = {};

    data.addAll({
      'fileId': fileId,
      'originalUrl': imageUrl,
      'thumbnailUrl' : thumbnailImageUrl,
    });

    return data;
  }
}

enum StorageType {
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
  prdCode,
  name,
  category,
  maker,
  storageType,
  stock,
  price,
  margin,
  active,
}
