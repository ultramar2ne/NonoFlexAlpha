import 'package:nonoflex_alpha/model/data/company.dart';
import 'package:nonoflex_alpha/model/repository/company/abs_company_repository.dart';

class CompanyMockRepository extends CompanyRepository{
  @override
  Future<void> addCompany() {
    // TODO: implement addCompany
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCompanyData() {
    // TODO: implement deleteCompanyData
    throw UnimplementedError();
  }

  @override
  Future<Company> getCompanyDetailinfo() {
    // TODO: implement getCompanyDetailinfo
    throw UnimplementedError();
  }

  @override
  Future<CompanyList> getCompanyList() {
    // TODO: implement getCompanyList
    throw UnimplementedError();
  }

  @override
  Future<void> updateCompanyActivation() {
    // TODO: implement updateCompanyActivation
    throw UnimplementedError();
  }

  @override
  Future<void> updateCompanyInfo() {
    // TODO: implement updateCompanyInfo
    throw UnimplementedError();
  }
}