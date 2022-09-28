class Notice {
// 공지사항 id : noticeid
  final int noticeId;

// 공지사항 제목 : title
  final String title;

// 공지사항 내용 : content
  final String? content;

// 작성자 이름 : writer
  final String writer;

// 최초 작성 시간 : createdAt
  final DateTime createdAt;

// 마지막 수정 시간 : updatedAt
  final DateTime updatedAt;

// 주요 공지사항 여부 : focus
  final bool isFocused;

  Notice(
      {required this.noticeId,
      required this.title,
      required this.content,
      required this.writer,
      required this.createdAt,
      required this.updatedAt,
      required this.isFocused});

  factory Notice.fromJson(Map<String, dynamic> data) {
    return Notice(
      noticeId: data['page'],
      title: data['page'],
      content: data['page'],
      writer: data['page'],
      createdAt: data['page'],
      updatedAt: data['page'],
      isFocused: data['page'],
    );
  }
}

class NoticeList {
  // 현재 페이지 : page
  final int page;

  // : count
  final int count;

  // : totalPages
  final int totalPages;

  // : totalCount
  final int totalCount;

  // : lastPage
  final bool isLastPage;

  // 거래처 목록 : companyList
  final List<Notice> items;

  NoticeList(
      {required this.page,
      required this.count,
      required this.totalPages,
      required this.totalCount,
      required this.isLastPage,
      required this.items});

  factory NoticeList.fromJson(Map<String, dynamic> data) {
    return NoticeList(
        page: data['page'],
        count: data['count'],
        totalPages: data['totalPages'],
        totalCount: data['totalCount'],
        isLastPage: data['isLastPage'],
        items: data['noticeList'].map((element) => Notice.fromJson(element)).toList());
  }
}
