import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/data/record.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';

abstract class ProductRepository {
  // 새 물품 추가
  Future<void> addProduct(Product product);

  // 물품 목록 조회
  Future<ProductList> getProductList({
    String? searchValue,
    ProductListSortType? sortType,
    String? orderType,
    int? size,
    int? page,
    bool? onlyActiveItem,
  });

  // 물품 상세 정보 조회
  Future<Product?> getProductDetailInfo({int? productId, String? barcode});

  // 물품 레코드 조회
  Future<List<RecordOfProduct>> getRecordByProduct(int productId, {int? year, int? month});

  // 물품 정보 수정
  Future<void> updateProductInfo(Product product);

  // 물품 정보 삭제
  Future<void> deleteProductData(Product producte);
}

class ProductRepositoryImpl extends ProductRepository {
  RemoteDataSource _remoteDataSource;

  ProductRepositoryImpl({RemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? locator.get<RemoteDataSource>();

  @override
  Future<void> addProduct(Product product) async {
    return await _remoteDataSource.addProduct(product);
  }

  @override
  Future<ProductList> getProductList({
    String? searchValue, // 검색 키워드 (제목 기반)
    ProductListSortType? sortType,
    String? orderType,
    int? size,
    int? page,
    bool? onlyActiveItem,
  }) async {
    return await _remoteDataSource.getProductList(
        searchValue: searchValue,
        sortType: sortType,
        orderType: orderType,
        size: size,
        page: page,
        onlyActiveItem: onlyActiveItem);
  }

  @override
  Future<Product?> getProductDetailInfo({int? productId, String? barcode}) async {
    if (productId == null && barcode == null) throw ('잘못된 요청');
    if (productId != null) {
      return await _remoteDataSource.getProductDetailInfoByProductId(productId);
    }
    if (barcode != null) return await _remoteDataSource.getProductDetailInfoByBarcode(barcode);
    return null;
  }

  @override
  Future<List<RecordOfProduct>> getRecordByProduct(int productId, {int? year, int? month}) async {
    return await _remoteDataSource.getProductRecords(
        productId: productId, year: year, month: month);
  }

  @override
  Future<void> updateProductInfo(Product product) async {
    return await _remoteDataSource.updateProduct(product: product);
  }

  @override
  Future<void> deleteProductData(Product product) async {
    await _remoteDataSource.deleteProduct(product.productId);
  }
}
