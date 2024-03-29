import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:nonoflex_alpha/conf/config.dart';
import 'package:nonoflex_alpha/conf/manager/auth_manager.dart';
import 'package:nonoflex_alpha/conf/ui/theme.dart';
import 'package:nonoflex_alpha/model/repository/auth/auth_repository.dart';
import 'package:nonoflex_alpha/model/repository/company/company_repository.dart';
import 'package:nonoflex_alpha/model/repository/document/document_repository.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';
import 'package:nonoflex_alpha/model/repository/user/user_repository.dart';
import 'package:nonoflex_alpha/model/source/local_data_source.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';

final GetIt locator = GetIt.instance;

/// 로케이터로 등록해서 사용할 기본 객체들을 설정함
/// Provider -> Data Source -> Repository 순으로 등록해야함
void setUpLocator() {
  // etc
  locator.registerSingleton<Logger>(Logger());
  locator.registerSingleton<Configs>(Configs());

  // config
  locator.registerSingleton<BNTheme>(LightTheme());

  // data source
  locator.registerSingleton<LocalDataSource>(LocalDataSourceImpl());
  locator.registerSingleton<RemoteDataSource>(RemoteDataSource());

  // repository
  locator.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  locator.registerSingleton<CompanyRepository>(CompanyRepositoryImpl());
  locator.registerSingleton<DocumentRepository>(DocumentRepositoryImpl());
  locator.registerSingleton<NoticeRepository>(NoticeRepositoryImpl());
  locator.registerSingleton<ProductRepository>(ProductRepositoryImpl());
  locator.registerSingleton<UserRepository>(UserRepositoryImpl());

  // manager
  locator.registerSingleton<AuthManager>(AuthManager());
}
