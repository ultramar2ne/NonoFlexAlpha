/// 거래처 정보
class Company {
  // 거래처 id : companyId
  final int companyId;

  // 거래처 이름 : name
  final String name;

  // 거래처 타입 : type
  final CompanyType companyType;

  // 거래처 추가 정보 : category
  final String description;

  // 거래처 활성 여부 : active
  final bool isActive;

  Company(
      {required this.companyId,
      required this.name,
      required this.companyType,
      required this.description,
      this.isActive = false});

  factory Company.fromJson(Map<String, dynamic> data) {
    return Company(
        companyId: data['companyId'],
        name: data['name'],
        companyType: data['companyType'],
        description: data['category'],
        isActive: data['active']);
  }
}

enum CompanyType { input, output }

/// 거래처 목록
class CompanyList {
  // 현재 페이지 : page
  final int page;

  //
  final int count;

  //
  final int totalPages;

  //
  final int totalCount;

  //
  final bool isLastPage;

  // 거래처 목록 : companyList
  final List<Company> items;

  CompanyList(
      {required this.page,
      required this.count,
      required this.totalPages,
      required this.totalCount,
      required this.isLastPage,
      required this.items});

  factory CompanyList.fromJson(Map<String, dynamic> data) {
    return CompanyList(
        page: data['page'],
        count: data['count'],
        totalPages: data['totalPages'],
        totalCount: data['totalCount'],
        isLastPage: data['isLastPage'],
        items: data['companyItems'].map((element) => Company.fromJson(element)).toList());
  }
}
