import 'package:nonoflex_alpha/model/data/company.dart';

enum CompanyListSortType { id, name, type, category }

abstract class CompanyRepository {
  /// 거래처 추가
  Future<void> addCompany(
      {required String name, required CompanyType type, required, String? description});

  /// 거래처 목록 조회
  Future<CompanyList> getCompanyList(
      {String? searchValue,
      CompanyListSortType? sortType,
      String? orderType,
      int? size,
      int? page,
      bool? onlyActive});

  /// 거래처 상세 정보 조회
  Future<Company> getCompanyDetailinfo(int companyId);

  /// 거래처 정보 수정
  Future<void> updateCompanyInfo(Company company);

  /// 거래처 활성 상태 변경
  Future<void> updateCompanyActivation(Map<int, bool> companyList);

  /// 거래처 정보 삭제
  Future<void> deleteCompanyData(int companyId);
}
