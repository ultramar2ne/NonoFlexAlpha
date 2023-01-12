import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/conf/manager/auth_manager.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/repository/document/document_repository.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';

class DocumentDetailViewModel extends BaseController {
  DocumentRepository _documentRepository;
  ProductRepository _productRepository;
  final AuthManager _authManager = locator.get<AuthManager>();

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
      updateLoadingState(true);
      documentInfo = await _documentRepository.getDocumentDetailInfo(documentId);
      update();
      updateLoadingState(false);
    } catch (e) {
      logger.e(e);
      updateLoadingState(false);
      await Get.alertDialog('알 수 없는 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.');
      Get.back();
    }
  }

  void loadProductDetailInfo(Product product) async {
    await baseNavigator.goProductDetailPage(product);
  }

  void goDocumentEditPage() async {
    if (documentInfo == null) return;
    await baseNavigator.goDocumentEditPage(documentInfo!);
    init();
  }

  void deleteDocument() async {
    if (!await Get.confirmDialog('정말 문서를 삭제하시겠습니까?\n삭제된 문서는 복구할 수 없습니다.')) return;
    try {
      await _documentRepository.deleteDcoumentData(documentId);
      Get.toast('문서가 삭제되었습니다.');
      Get.back();
    } catch (e) {
      logger.e(e);
      await Get.alertDialog('알 수 없는 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.');
    }
  }

  bool checkDocumentDeleteValidation() {
    if (documentInfo == null) return false;

    final differ = documentInfo!.createdAt.difference(DateTime.now());

    if (configs.isAdminMode) {
      return differ.inDays < 50;
    } else {
      if (documentInfo!.writerId != _authManager.currentUser?.userCode) return false;
      return differ.inDays < 3;
    }
  }

  bool checkDocumentEditValidation() {
    if (documentInfo == null) return false;

    final differ = documentInfo!.createdAt.difference(DateTime.now());

    if (configs.isAdminMode) {
      return differ.inDays < 50;
    } else {
      if (documentInfo!.writerId != _authManager.currentUser?.userCode) return false;
      return differ.inDays < 3;
    }
  }
}
