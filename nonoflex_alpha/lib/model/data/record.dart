import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/product.dart';

/// 문서에 기록되는 물품의 정보
/// [Document] 와 [Product] 각각에서 필요한 정보에 맞게 상속받아 사용
abstract class Record {
  /// 레코드 고유 ID : recordId
  final int recordId;

  /// 물품 ID : productId
  final int productId;

  /// 문서 ID : documentId
  final int documentId;

  /// 입/출고 갯수 : quantity
  final int quantity;

  /// 입/출고 금액 : price
  final int recordPrice;

  Record(
    this.recordId,
    this.productId,
    this.documentId,
    this.quantity,
    this.recordPrice,
  );
}

/// 물품 정보에서 필요한 [Record] 정보
class RecordOfProduct extends Record {
  /// 레코드 고유 ID : recordId
  @override
  final int recordId;

  /// 물품 ID
  @override
  final int productId;

  /// 문서 ID
  @override
  final int documentId;

  /// 물품 출입고 갯수 : quantity
  final int quantity;

  /// 해당 시점의 재고 : stock
  final int stock;

  /// 출입고 가격 : price
  @override
  final int recordPrice;

  /// document 입출고 날짜 : date
  final DateTime date;

  /// document 종류 : type
  final DocumentType docType;

  /// document 작성자 : documentId
  final String writer;

  RecordOfProduct({
    required this.recordId,
    required this.productId,
    required this.documentId,
    required this.quantity,
    required this.stock,
    required this.recordPrice,
    required this.date,
    required this.docType,
    required this.writer,
  }) : super(recordId, productId, documentId, quantity, recordPrice);

  RecordOfProduct copyWith({
    int? quantity,
    int? stock,
    int? price,
    DateTime? date,
    DocumentType? docType,
    String? writer,
  }) {
    return RecordOfProduct(
      recordId: recordId,
      productId: productId,
      documentId: documentId,
      quantity: quantity ?? this.quantity,
      stock: stock ?? this.stock,
      recordPrice: price ?? this.recordPrice,
      date: date ?? this.date,
      docType: docType ?? this.docType,
      writer: writer ?? this.writer,
    );
  }

  factory RecordOfProduct.fromJson(Map<String, dynamic> data) {
    final recordId = data['recordId'];
    final productId = data['productId'];
    final documentId = data['documentId'];
    final quantity = data['quantity'];
    final stock = data['stock'];
    final price = data['price'];
    final date = DateTime.parse(data['date']);
    final docType = DocumentType.getByServer(data['docType']);
    final writer = data['writer'];

    return RecordOfProduct(
      recordId: recordId,
      productId: productId,
      documentId: documentId,
      quantity: quantity,
      stock: stock,
      recordPrice: price,
      date: date,
      docType: docType,
      writer: writer,
    );
  }

  Map<String, dynamic> toMap({bool forServer = true}) {
    Map<String, dynamic> data = {};

    data.addAll({
      'recordId': recordId,
      'quantity': quantity,
      'stock': stock,
      'price': recordPrice,
      'date': date,
      'type': docType.serverValue,
      'writer': writer,
      'documentId': documentId,
    });

    return data;
  }
}

/// 문서에서 필요한 [Record] 정보
class RecordOfDocument extends Record {
  /// 레코드 고유 ID : recordId
  @override
  final int recordId;

  /// 물품 ID
  @override
  final int productId;

  /// 문서 ID
  @override
  final int documentId;

  /// 물품 정보 : product
  final Product productInfo;

  /// 물품 출입고 갯수 : quantity
  @override
  final int quantity;

  /// 해당 시점의 재고 : stock
  final int stock;

  /// 출입고 가격 : price
  @override
  final int recordPrice;

  RecordOfDocument({
    required this.recordId,
    required this.productId,
    required this.documentId,
    required this.productInfo,
    required this.quantity,
    required this.stock,
    required this.recordPrice,
  }) : super(recordId, productId, documentId, quantity, recordPrice);

  factory RecordOfDocument.fromJson(Map<String, dynamic> data, int documentId) {
    final recordId = data['recordId'] ?? -1;
    final productId = data['productId'] ?? -1;
    final productInfo = Product.fromJson(data['product']);
    final quantity = data['quantity'] ?? -1;
    final stock = data['stock'] ?? -1;
    final price = data['price'] ?? -1;

    return RecordOfDocument(
      recordId: recordId,
      productId: productId,
      documentId: documentId,
      productInfo: productInfo,
      quantity: quantity,
      stock: stock,
      recordPrice: price,
    );
  }

  Map<String, dynamic> toMap({bool forServer = true}) {
    Map<String, dynamic> data = {};

    data.addAll({
      'recordId': recordId,
      'quantity': quantity,
      'product': productInfo.toMap(),
      'stock': stock,
      'price': recordPrice,
      'documentId': documentId,
    });

    return data;
  }
}
