class Record {
  // 레코드 고유 ID : recordId
  final int recordId;

  // 물품 출입고 갯수 : quantity
  final int quantity;

  // 해당 시점의 재고 : stock
  final int stock;

  // 출입고 가격 : price
  final int price;

  // 레코드 생성 시각 : createdAt
  final DateTime createdAt;

  // 레코드 수정 시각 : updatedAt
  final DateTime updatedAt;

  Record(this.recordId, this.quantity, this.stock, this.price, this.createdAt, this.updatedAt);

  // factory Record.fromJson(Map<String,dynamic> data){
  //   return Record(recordId, quantity, stock, price, createdAt, updatedAt)
  // }
}

class RecordList{

}