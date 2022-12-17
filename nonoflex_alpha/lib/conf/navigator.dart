import 'package:get/get.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/view/document/document_list_view.dart';
import 'package:nonoflex_alpha/view/document/document_list_viewmodel.dart';
import 'package:nonoflex_alpha/view/login/login_view.dart';
import 'package:nonoflex_alpha/view/login/login_viewmodel.dart';
import 'package:nonoflex_alpha/view/main/main_admin_home_view.dart';
import 'package:nonoflex_alpha/view/main/main_admin_home_viewmodel.dart';
import 'package:nonoflex_alpha/view/main/main_admin_view.dart';
import 'package:nonoflex_alpha/view/main/main_admin_viewmodel.dart';
import 'package:nonoflex_alpha/view/main/main_participant_view.dart';
import 'package:nonoflex_alpha/view/main/main_participant_viewmodel.dart';
import 'package:nonoflex_alpha/view/more/setting_view.dart';
import 'package:nonoflex_alpha/view/more/setting_viewmodel.dart';
import 'package:nonoflex_alpha/view/notice/add_notice_view.dart';
import 'package:nonoflex_alpha/view/notice/add_notice_viewmodel.dart';
import 'package:nonoflex_alpha/view/notice/notice_detail_view.dart';
import 'package:nonoflex_alpha/view/notice/notice_detail_viewmodel.dart';
import 'package:nonoflex_alpha/view/notice/notice_list_view.dart';
import 'package:nonoflex_alpha/view/notice/notice_list_viewmodel.dart';
import 'package:nonoflex_alpha/view/product/add_product_view.dart';
import 'package:nonoflex_alpha/view/product/add_product_viewmodel.dart';
import 'package:nonoflex_alpha/view/product/product_detail_view.dart';
import 'package:nonoflex_alpha/view/product/product_detail_viewmodel.dart';
import 'package:nonoflex_alpha/view/product/product_list_view.dart';
import 'package:nonoflex_alpha/view/product/product_list_viewmodel.dart';
import 'package:nonoflex_alpha/view/splash/splash_view.dart';
import 'package:nonoflex_alpha/view/splash/splash_viewmodel.dart';
import 'package:nonoflex_alpha/view/util/scanner_view.dart';
import 'package:nonoflex_alpha/view/util/scanner_viewModel.dart';

class NonoNavigatorManager {
  bool get isTabletView => Get.size.shortestSide <= 600;

  // static const rootNavigatorKey = 0;
  static const nestedNavigatorKey = 1;

  static const tabletNavigatorKey = 2;

  // ==== Splash ====
  Future<dynamic> goSplashPage() async {
    const path = '/';

    return await Get.to(
      SplashView(),
      routeName: path,
      transition: Transition.fade,
      binding: BindingsBuilder(() => Get.lazyPut(() => SplashViewModel())),
      // id: rootNavigatorKey,
    );
  }

  // ==== Login ====
  Future<dynamic> goLoginPage() async {
    const path = '/login';

    return await Get.off(
      LoginView(),
      routeName: path,
      transition: Transition.fade,
      binding: BindingsBuilder(() => Get.lazyPut(() => LoginViewModel())),
      // id: rootNavigatorKey,
    );
  }

  // ==== Main ====
  Future<dynamic> goMainPage() async {
    const path = '/main';

    return await Get.off(
      MainForParticView(),
      routeName: path,
      transition: Transition.fade,
      binding: BindingsBuilder(() => Get.lazyPut(() => MainForParticViewModel())),
    );
  }

  Future<dynamic> goAdminMainPage() async {
    const path = '/admin/main';

    return await Get.off(
      MainForAdminView(),
      routeName: path,
      transition: Transition.fade,
      binding: BindingsBuilder(() => Get.lazyPut(() => MainForAdminViewModel())),
    );
  }

  Future<dynamic> goAdminHomePage({bool isNested = false}) async {
    const path = '/home';

    return await Get.off(
      AdminHomeView(),
      routeName: path,
      transition: Transition.fade,
      binding: BindingsBuilder(() => Get.lazyPut(() => AdminHomeViewModel())),
      id: isNested ? nestedNavigatorKey : null,
    );
  }

  Future<dynamic> goProductListPage({bool isNested = false}) async {
    const path = '/products';

    return await Get.off(
      ProductListView(),
      routeName: path,
      transition: Transition.fade,
      binding: BindingsBuilder(() => Get.lazyPut(() => ProductListViewModel())),
      id: isNested ? nestedNavigatorKey : null,
    );
  }

  Future<dynamic> goDocumentListPage({bool isNested = false}) async {
    const path = '/documents';

    return await Get.off(
      DocumentListView(),
      routeName: path,
      transition: Transition.fade,
      binding: BindingsBuilder(() => Get.lazyPut(() => DocumentListViewModel())),
      id: isNested ? nestedNavigatorKey : null,
    );
  }

  Future<dynamic> goSettingPage({bool isNested = false}) async {
    const path = '/setting';

    return await Get.off(
      SettingView(),
      routeName: path,
      transition: Transition.fade,
      binding: BindingsBuilder(() => Get.lazyPut(() => SettingViewModel())),
      id: isNested ? nestedNavigatorKey : null,
    );
  }

  // ==== Notice ====
  Future<dynamic> goNoticeListPage() async {
    const path = '/notice';

    return await Get.to(
      NoticeListView(),
      routeName: path,
      transition: Transition.downToUp,
      binding: BindingsBuilder(() => Get.lazyPut(() => NoticeListViewModel())),
      // id: rootNavigatorKey,
    );
  }

  Future<dynamic> goAddNoticePage() async {
    const path = '/notice/add';

    return await Get.to(
      AddNoticeView(),
      routeName: path,
      transition: Transition.downToUp,
      binding: BindingsBuilder(() => Get.lazyPut(() => AddNoticeViewModel())),
      // id: rootNavigatorKey,
    );
  }

  Future<dynamic> goNoticeDetailPage(Notice noticeItem) async {
    const path = '/notice/detail';

    return await Get.to(
      NoticeDetailView(),
      routeName: path,
      arguments: {'noticeId': noticeItem.noticeId.toString()},
        transition: Transition.downToUp,
      binding: BindingsBuilder(() => Get.lazyPut(() => NoticeDetailViewModel(noticeItem: noticeItem))),
      // id: rootNavigatorKey,
    );
  }

  // ==== Product ====
  Future<dynamic> goProductDetailPage(Product product) async {
    const path = '/product/detail';

    return await Get.to(
      ProductDetailView(),
      routeName: path,
      transition: Transition.downToUp,
      arguments: {'productId': product.prdId.toString()},
      binding:
          BindingsBuilder(() => Get.lazyPut(() => ProductDetailViewModel(productItem: product))),
      // id: rootNavigatorKey,
    );
  }

  Future<dynamic> goAddProductPage() async {
    const path = '/product/add';

    return await Get.to(
      AddProductView(),
      routeName: path,
      // transition: Transition.downToUp,
      binding: BindingsBuilder(() => Get.lazyPut(() => AddProductViewModel())),
      // id: rootNavigatorKey,
    );
  }

  // ==== Utils ====
  Future<dynamic> goScannerPage() async {
    const path = '/app/scanner';

    return await Get.to(
      ScannerView(),
      routeName: path,
      transition: Transition.downToUp,
      binding: BindingsBuilder(() => Get.lazyPut(() => ScannerViewModel())),
      // id: null,
    );
  }
}
