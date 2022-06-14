import 'package:scanner/item_qrcode.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ScannerHelper {
  static const  String nomeTabela = 'qrcode';
  static const  String columnId = 'id';
  static const  String columntitle = 'title';
  static const  String columnDescription = 'description';
  static const  String columnDate = 'date';

  static final ScannerHelper _scannerHelper = ScannerHelper._internal();
  Database? _db;
  factory ScannerHelper() {
    return _scannerHelper;
  }

  ScannerHelper._internal() ;

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    await db.execute(_sql);
  }

  String get _sql => '''
CREATE TABLE $nomeTabela(
$columnId INTEGER PRIMARY KEY AUTOINCREMENT,
$columntitle VARCHAR,
$columnDescription TEXT,
$columnDate DATETIME);
''';
  inicializarDB() async {
    final caminhoBanco = await getDatabasesPath();
    final localBanco =  join(caminhoBanco, 'qrcode.db');
    var db = await openDatabase(localBanco, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> salvarQRcode(ItemQRcode itemQRcode) async {
    var bancoDados = await db;
    int resultado = await bancoDados.insert(nomeTabela, itemQRcode.toMap());
    return resultado;
  }

  recuperarQRcode() async {
    var bancoDados = await db;
    String sql = 'SELECT*FROM $nomeTabela ORDER BY $columnDate DESC';
    List qrCodes = await bancoDados.rawQuery(sql);
    return qrCodes;
  }

  Future<int> atualizarQRcode(ItemQRcode itemQRcode) async {
    var bancoDados = await db;
    return await bancoDados.update(nomeTabela, itemQRcode.toMap(),
        where: 'id=?', whereArgs: [itemQRcode.id]);
  }

  Future<int> removerQRcode(int id)async{
var bancoDados=await db;
return await bancoDados.delete(
  nomeTabela,
  where:'id=?',
  whereArgs:[id]
);
  }
}
