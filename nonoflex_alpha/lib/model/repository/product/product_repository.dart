import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/data/record.dart';

abstract class ProductRepository {
  // 새 물품 추가
  Future<void> addProduct();

  // 물품 목록 조회
  Future<ProductList> getProductList();

  // 물품 상세 정보 조회
  Future<Product> getProductDetailInfo();

  // 물품 레코드 조회
  Future<RecordList> getRecordByProduct();

  // 물품 정보 수정
  Future<void> updateProductInfo();

  // 물품 정보 삭제
  Future<void> deleteProductData();
}

class ProductRepositoryImpl extends ProductRepository {
  @override
  Future<void> addProduct() {
    // TODO: implement addProduct
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProductData() {
    // TODO: implement deleteProductData
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductDetailInfo() {
    // TODO: implement getProductDetailInfo
    throw UnimplementedError();
  }

  @override
  Future<ProductList> getProductList() {
    // TODO: implement getProductList
    throw UnimplementedError();
  }

  @override
  Future<RecordList> getRecordByProduct() {
    // TODO: implement getRecordByProduct
    throw UnimplementedError();
  }

  @override
  Future<void> updateProductInfo() {
    // TODO: implement updateProductInfo
    throw UnimplementedError();
  }
}
