import 'package:scanner/db_helper.dart';

class ItemQRcode {
  int? id;
 late String title;
 late String description;
 late String date;

  ItemQRcode(
      {this.id,
      required this.title,
      required this.description,
      required this.date});

ItemQRcode.fromMap(Map map){
  this.id=map[ScannerHelper.columnId];
  this.title=map[ScannerHelper.columntitle];
  this.description=map[ScannerHelper.columnDescription];
  this.date=map[ScannerHelper.columnDate];
}


  Map toMap() {
    Map<String, dynamic> map = {
      ScannerHelper.columntitle: this.title,
      ScannerHelper.columnDescription: this.description,
      ScannerHelper.columnDate: this.date,
    };
    if (this.id != null) {
      map[ScannerHelper.columnId] = this.id;
    }
    return map;
  }
}
