import 'package:get_it/get_it.dart';
import 'package:nonoflex_alpha/model/repository/auth/abs_auth_repository.dart';
import 'package:nonoflex_alpha/model/repository/auth/auth_repository.dart';
import 'package:nonoflex_alpha/model/repository/company/abs_company_repository.dart';
import 'package:nonoflex_alpha/model/repository/company/company_repository.dart';
import 'package:nonoflex_alpha/model/repository/document/abs_document_repository.dart';
import 'package:nonoflex_alpha/model/repository/document/document_mock_repository.dart';
import 'package:nonoflex_alpha/model/repository/notice/abs_notice_repository.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';
import 'package:nonoflex_alpha/model/repository/product/abs_product_repository.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';
import 'package:nonoflex_alpha/model/repository/user/abs_user_repository.dart';
import 'package:nonoflex_alpha/model/repository/user/user_repository.dart';
import 'package:nonoflex_alpha/model/source/local_data_source.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';

final GetIt locator = GetIt.instance;

/// 로케이터로 등록해서 사용할 기본 객체들을 설정함
/// Provider -> Data Source -> Repository 순으로 등록해야함
void setUpLocator(){

  // server config

  // data source
  locator.registerSingleton<LocalDataSource>(LocalDataSource());
  locator.registerSingleton<RemoteDataSource>(RemoteDataSource());

  // repository
  locator.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  locator.registerSingleton<CompanyRepository>(CompanyRepositoryImpl());
  locator.registerSingleton<DocumentRepository>(DocumentRepositoryImpl());
  locator.registerSingleton<NoticeRepository>(NoticeRepositoryImpl());
  locator.registerSingleton<ProductRepository>(ProductRepositoryImpl());
  locator.registerSingleton<UserRepository>(UserRepositoryImpl());




}