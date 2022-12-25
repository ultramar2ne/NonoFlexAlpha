import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/company.dart';
import 'package:nonoflex_alpha/model/repository/company/company_repository.dart';

class CompanyListViewModel extends BaseController {
  CompanyRepository _companyRepository;

  List<Company> companyItems = [];

  /// start company List 관련 설정
  String searchValue = ''; // 검색어
  CompanyListSortType sortType = CompanyListSortType.name; // 정렬 기준
  bool isDesc = true; // 정렬 방향
  final int pageSize = 30; // 페이지 호출 개수
  bool onlyActiveItem = false; //

  int pageNum = 1; // 현재 페이지
  bool isLastPage = false; // 마지막 페이지 여부
  /// end

  CompanyListViewModel({CompanyRepository? companyRepository})
      : _companyRepository = companyRepository ?? locator.get<CompanyRepository>() {
    init();
  }

  init() {
    getCompanyList();
  }

  Future<void> getCompanyList() async {
    try {
      final list = await _companyRepository.getCompanyList(
        searchValue: searchValue,
        // sortType: sortType,
        // orderType:
        // page: pageSize,
        onlyActive: onlyActiveItem,
      );
      companyItems = list.items;
      update();
    } catch (e) {
      logger.e(e);
    }
  }
}
