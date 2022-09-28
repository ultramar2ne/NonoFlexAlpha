class Product {
  // 서버에서 관리되는 물품 고유 id : productId;
  final int prdId;

  // 기관에서 관리하는 물품 고유 코드 : prdCode;
  final String prdCode;

  // 상품 이름 : name
  final String prdName;

  // 상품 이미지 파일 주소 : fileUri
  final String? fileUri;

  // 상품 상세 설명 : description
  final String? description;

  // 분류 : category
  final String? category;

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
  final int price;

  // 마진율 : marign
  final int marginPrice;

  // 물품 활성 여부 : active
  final bool isActive;

  Product({
    required this.prdId,
    required this.prdCode,
    required this.prdName,
    required this.fileUri,
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

  factory Product.fromJson(Map<String, dynamic> data){
    return Product(
        prdId: data['page'],
        prdCode: data['page'],
        prdName: data['page'],
        fileUri: data['page'],
        description: data['page'],
        category: data['page'],
        maker: data['page'],
        unit: data['page'],
        storageType: data['page'],
        barcode: data['page'],
        stock: data['page'],
        price: data['page'],
        marginPrice: data['page'],
        isActive: data['page']);
  }
}

enum StorageType {
  ICE,
  COLD,
  ROOM,
}

// class ProductDetail extends Product {
//   // product 목록에서 나타나는 데이터에 추가 데이터가 존재하지 않는가?
// }

class ProductList {
  // 현재 페이지 : page
  final int page;

  // : count
  final int count;

  // 거래처 목록 : companyList
  final List<Product> items;

  ProductList({required this.page, required this.count, required this.items});

  factory ProductList.fromJson(Map<String, dynamic> data) {
    return ProductList(
        page: data['page'],
        count: data['count'],
        items: data['productList'].map((element) => Product.fromJson(element)).toList());
  }
}
