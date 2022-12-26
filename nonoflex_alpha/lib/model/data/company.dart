import 'package:flutter/cupertino.dart';

/// 거래처 정보
@immutable
class Company {
  // 거래처 id : companyId
  final int companyId;

  // 거래처 이름 : name
  final String name;

  // 거래처 타입 : type
  final CompanyType companyType;

  // 거래처 추가 정보 : category
  final String? description;

  // 거래처 활성 여부 : active
  final bool isActive;

  Company(
      {required this.companyId,
      required this.name,
      required this.companyType,
      this.description,
      this.isActive = false});

  Company copyWith({
    int? companyId,
    String? name,
    CompanyType? companyType,
    String? description,
    bool? isActive,
  }) {
    return Company(
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      companyType: companyType ?? this.companyType,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  factory Company.fromJson(Map<String, dynamic> data) {
    return Company(
        companyId: data['companyId'],
        name: data['name'],
        companyType: CompanyType.fromServer(data['type']),
        description: data['category'],
        isActive: data['active']);
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'name': name,
      'companyType': companyType.serverValue,
      'category': description,
      'isActive': isActive,
    };
  }
}

/// 거래처 종
enum CompanyType {
  none('none', ''),
  input('input', 'INPUT'),
  output('output', 'OUTPUT');

  const CompanyType(this.code, this.serverValue);

  final String code;
  final String serverValue;

  factory CompanyType.fromServer(String serverValue) {
    return CompanyType.values
        .firstWhere((value) => value.serverValue == serverValue, orElse: () => CompanyType.none);
  }
}

extension CompanyTypeExt on CompanyType{
  String get displayName {
    switch (this) {
      case CompanyType.input:
        return '입고처';
      case CompanyType.output:
        return '출고처';
      default:
        return '';
    }
  }
}

/// 거래처 목록
class CompanyList {
  // 현재 페이지 : page
  final int page;

  // ?? : count
  final int count;

  // 전체 페이지 개수 : totalPages
  final int totalPages;

  // 전체 목록 개수 : totalCount
  final int totalCount;

  // 마지막 페이지 여부 : lastPage
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
    final metaData = data['meta'];
    final items = data['companyList'];

    return CompanyList(
        page: metaData['page'],
        count: metaData['count'],
        totalPages: metaData['totalPages'],
        totalCount: metaData['totalCount'],
        isLastPage: metaData['lastPage'],
        items: items.map<Company>((element) => Company.fromJson(element)).toList());
  }
}

enum CompanyListSortType {
  id,
  name,
  type,
  category, // 이게 맞아..?
}
