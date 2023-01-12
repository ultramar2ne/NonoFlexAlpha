import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/company.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';

abstract class CompanyRepository {
  /// 거래처 추가
  Future<void> addCompany(
      {required String name, required CompanyType type, required, String? description});

  /// 거래처 목록 조회
  Future<CompanyList> getCompanyList({
    String? searchValue,
    CompanyListSortType? sortType,
    String? orderType,
    int? size,
    int? page,
    bool? onlyActive,
    String? type,
  });

  /// 거래처 상세 정보 조회
  Future<Company> getCompanyDetailinfo(int companyId);

  /// 거래처 정보 수정
  Future<void> updateCompanyInfo(Company company);

  /// 거래처 활성 상태 변경
  Future<void> updateCompanyActivation(Map<int, bool> companyList);

  /// 거래처 정보 삭제
  Future<void> deleteCompanyData(int companyId);
}

class CompanyRepositoryImpl extends CompanyRepository {
  final RemoteDataSource _remoteDataSource;

  CompanyRepositoryImpl({RemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? locator.get<RemoteDataSource>();

  @override
  Future<void> addCompany(
      {required String name, required CompanyType type, required, String? description}) {
    return _remoteDataSource
        .addCompany(Company(companyId: 0, name: name, description: description, companyType: type));
  }

  @override
  Future<void> deleteCompanyData(int companyId) {
    return _remoteDataSource.deleteCompany(companyId);
  }

  @override
  Future<Company> getCompanyDetailinfo(int companyId) {
    return _remoteDataSource.getCompanyDetailInfoByCompanyId(companyId);
  }

  @override
  Future<CompanyList> getCompanyList({
    String? searchValue,
    CompanyListSortType? sortType,
    String? orderType,
    int? size,
    int? page,
    bool? onlyActive,
    String? type,
  }) {
    return _remoteDataSource.getCompanyList(
      searchValue: searchValue,
      sortType: sortType,
      orderType: orderType,
      size: size,
      page: page,
      onlyActiveItem: onlyActive,
      type: type,
    );
  }

  @override
  Future<void> updateCompanyActivation(Map<int, bool> companyList) {
    // TODO: implement updateCompanyActivation
    throw UnimplementedError();
  }

  @override
  Future<void> updateCompanyInfo(Company company) {
    return _remoteDataSource.updateCompany(company: company);
  }
}
