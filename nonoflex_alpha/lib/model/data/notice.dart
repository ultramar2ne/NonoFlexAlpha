
import 'package:flutter/cupertino.dart';

/// 공지사항
@immutable
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

  Notice copyWith({String? title, String? content, bool? isFocused}) {
    return Notice(
      noticeId: noticeId,
      title: title ?? this.title,
      content: content ?? this.content,
      writer: writer,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isFocused: isFocused ?? this.isFocused,
    );
  }

  factory Notice.fromJson(Map<String, dynamic> data) {
    return Notice(
      noticeId: data['noticeId'],
      title: data['title'],
      content: data['content'],
      writer: data['writer'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      isFocused: data['focus'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'noticeId': noticeId,
      'title': title,
      'content': content,
      'writer': writer,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'focus': isFocused
    };
  }
}

/// 공지사항 목록
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

  // 공지사항 목록 : companyList
  final List<Notice> items;

  NoticeList(
      {required this.page,
      required this.count,
      required this.totalPages,
      required this.totalCount,
      required this.isLastPage,
      required this.items});

  factory NoticeList.fromJson(Map<String, dynamic> data) {
    final metaData = data['meta'];
    final items = data['noticeList'];

    return NoticeList(
        page: metaData['page'],
        count: metaData['count'],
        totalPages: metaData['totalPages'],
        totalCount: metaData['totalCount'],
        isLastPage: metaData['lastPage'],
        items: items.map<Notice>((el) => Notice.fromJson(el as Map<String, dynamic>)).toList());
  }
}
