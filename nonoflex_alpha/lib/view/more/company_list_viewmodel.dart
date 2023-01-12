import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
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
  final int pageSize = 1000; // 페이지 호출 개수 // company는 한번에 모두 호출
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
        size: pageSize,
        onlyActive: onlyActiveItem,
      );
      companyItems = list.items;
      update();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> addNewCompany(String companyName, String? description,
      CompanyType companyType) async {
    if (companyName.replaceAll(' ', '') == '') return;
    try {
      await _companyRepository.addCompany(
          name: companyName, description: description, type: companyType);
      Get.toast('거래처 정보가 추가되었습니다.');
      init();
    } catch (e) {
      logger.e(e);
      Get.toast('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }
  }

  Future<void> updateCompanyInfo(Company company) async {
    try {
      await _companyRepository.updateCompanyInfo(company);
      Get.toast('거래처 정보가 수정되었습니다.');
      init();
    } catch (e) {
      logger.e(e);
      Get.toast('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }
  }

  Future<void> deleteCompnayInfo(Company compnay) async {
    if (!await Get.confirmDialog(
        '정말로 삭제하시겠습니까? \n삭제된 데이터는 복구할 수 없습니다. \n영구적인 삭제를 원하지 않으신다면 비활성화를 추천드립니다.')) {
      return;
    }

    try {
      await _companyRepository.deleteCompanyData(compnay.companyId);
      Get.toast('거래처 정보가 삭제되었습니다.');
      init();
    } catch (e) {
      Get.toast('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      logger.e(e);
    }
  }
}
