import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/data/record.dart';
import 'package:nonoflex_alpha/model/source/local_data_source.dart';
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
  Future<void> deleteProductData(int productId);

  // 물품 이미지 등록
  Future<ProductImage> uploadProductImage(String filePath);

  // 물품 목록 정렬 기준 조회
  Future<ProductSortingSet?> getProductSortInfo();

  // 물품 목록 정렬 기준 업데이트
  Future<void> updateProductSortInfo(ProductSortingSet sortingSet);

  // 물품 목록 정렬 기준 초기화
  Future<void> clearProductSortInfo();
}

class ProductRepositoryImpl extends ProductRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  ProductRepositoryImpl({RemoteDataSource? remoteDataSource, LocalDataSource? localDataSource})
      : _remoteDataSource = remoteDataSource ?? locator.get<RemoteDataSource>(),
        _localDataSource = localDataSource ?? locator.get<LocalDataSource>();

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
  Future<List<RecordOfProduct>> getRecordByProduct(int productId, {int? year, int? month}) {
    return _remoteDataSource.getProductRecords(productId: productId, year: year, month: month);
  }

  @override
  Future<void> updateProductInfo(Product product) {
    return _remoteDataSource.updateProduct(product: product);
  }

  @override
  Future<void> deleteProductData(int productId) async {
    await _remoteDataSource.deleteProduct(productId);
  }

  @override
  Future<ProductImage> uploadProductImage(String filePath) {
    return _remoteDataSource.uploadProductImage(filePath);
  }

  @override
  Future<ProductSortingSet?> getProductSortInfo() async {
    final userInfo = await _localDataSource.getUserInfo();
    if (userInfo == null) return null;

    return await _localDataSource.getProductSortingSet(userInfo.userCode);
  }

  @override
  Future<void> updateProductSortInfo(ProductSortingSet sortingSet) async {
    final userInfo = await _localDataSource.getUserInfo();
    if (userInfo == null) return; // TODO: throw...?

    await _localDataSource.updateProductSortingSet(userInfo.userCode, sortingSet);
  }

  @override
  Future<void> clearProductSortInfo() async {
    final userInfo = await _localDataSource.getUserInfo();
    if (userInfo == null) return; // TODO: throw...?

    await _localDataSource.clearProductSortingSet(userInfo.userCode);
  }
}
