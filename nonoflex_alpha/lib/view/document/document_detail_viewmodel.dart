import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/repository/document/document_repository.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';

class DocumentDetailViewModel extends BaseController {
  DocumentRepository _documentRepository;
  ProductRepository _productRepository;

  // 문서 id
  final int documentId;

  // 문서 정보
  DocumentDetail? documentInfo;

  DocumentDetailViewModel({
    required this.documentId,
    DocumentRepository? documentRepository,
    ProductRepository? productRepository,
  })  : _documentRepository = documentRepository ?? locator.get<DocumentRepository>(),
        _productRepository = productRepository ?? locator.get<ProductRepository>() {
    init();
  }

  void init() async {
    try {
      documentInfo = await _documentRepository.getDocumentDetailInfo(documentId);
      update();
    } catch (e) {
      /// 오류 표출, 종료
    }
  }

  void loadProductDetailInfo(Product product) async {
    await baseNavigator.goProductDetailPage(product);
  }

  void goDocumentEditPage() async {
    final result = await baseNavigator.goDocumentEditPage(documentId);
    if (result != null) {
      init();
    }
  }
}
