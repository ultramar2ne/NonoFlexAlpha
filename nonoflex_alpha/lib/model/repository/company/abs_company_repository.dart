import 'package:nonoflex_alpha/model/data/company.dart';

abstract class CompanyRepository {
  // 거래처 추가
  Future<void> addCompany();

  // 거래처 목록 조회
  Future<CompanyList> getCompanyList();

  // 거래처 상세 정보 조회
  Future<Company> getCompanyDetailinfo();

  // 거래처 정보 수정
  Future<void> updateCompanyInfo();

  // 거래처 활성 상태 변경
  Future<void> updateCompanyActivation();

  // 거래처 정보 삭제
  Future<void> deleteCompanyData();
}
