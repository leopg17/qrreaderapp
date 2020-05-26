import 'dart:io';

import 'package:path/path.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  
  static Database _database;
  // Constructor privado
  static final DBProvider db = DBProvider._(); 

  DBProvider._();

  Future <Database> get database async{
    //Consultamos si ya existe la base de datos
    if (_database != null) return _database; // En caso de que ya exista la DB, nos devuelve esa DB
    // De lo contrario creamos la base de datos
    _database = await initDB();

    return _database;
  }
  //initDB es un metodo que procedemos a crear
  initDB() async {
    //Crea el path de donde se va a encontrar la base de datos
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    //Esto nos permite unir la ruta donde se encuentra la DB con el nombre del archivo para unirlos
    final path = join(documentDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path, // Ruta
      version: 1, // Si se hiciera un cambio una nueva tabla o nuevas realaciones
      // o mas tablas se debe de cambiar la versión.
      onOpen: (db) {}, // no se va a usar
      onCreate: (Database db, int version) async{ //Ya esta creada y lista para usarla
        await db.execute( // En este momento podriamos proceder a crear todas las tablas que necesitemos
          'CREATE TABLE Scans (' //No necesariamente debe de ser en mayuscula. Nombre de la tabla
          'id INTEGER PRIMARY KEY,'// Llave primaria, auto incremental
          'tipo TEXT,'
          'valor TEXT'
          ')'
        ); // Si ya existe la DB no se crea, si no existe procede a crearla
      }
    );
    
  }

  //CREAR Registros
  nuevoScanRaw(ScanModel nuevoScan) async {//Aqui tengo toda la información de lo que se escaneo
    final db = await database;
    final res = await db.rawInsert(
      "INSERT Into Scans (id, tipo, valor) "//Dejamos un espacio al final
      "VALUES (${ nuevoScan.id }, '${ nuevoScan.tipo}', '${ nuevoScan.valor }')"
    );
    return res;
  }

  //Este metodo hace lo mismo que el anterior, es mas sencillo.
  //Pero es importante conocer el modelo anterior
  //Tambien con este modelo es mas rapido, con el anterior tendriamos que escribir cada inserción
  nuevoScan(ScanModel nuevoScan) async { 
    final db = await database; 
    final res = await db.insert('Scans', nuevoScan.toJson()); // Esta es mas segura que la anterior
    return res; 
  }

  //Select - Obtener información
  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    //Signo de pregunta en los Where significa que tiene que ser un argumento
    final res = await db.query('Scans', where: 'id=?', whereArgs: [id]);
    //Esto va a retornar un lista de mapas(json), ocupo el primer elemento
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  //Si necesito traer todos los scans
  Future <List<ScanModel>> getTodosScans() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty //Si esto no esta vacio
                              ? res.map((e) => ScanModel.fromJson(e)).toList() //Va a proceder a crear instancias de ScanModel
                              :[]; //En caso contratrio va a retornar una lista vacia
    return list;

  }

  // Si necesito retornar una lista por tipo
  Future <List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROMS Scans WHERE tipo='$tipo'");

    List<ScanModel> list = res.isNotEmpty //Si esto no esta vacio
                              ? res.map((e) => ScanModel.fromJson(e)).toList() //Va a proceder a crear instancias de ScanModel
                              :[]; //En caso contratrio va a retornar una lista vacia
    return list;

  }
  
  //Actualizar registros

  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id=?', whereArgs: [nuevoScan.id] );
    return res;
  }

  //Eliminar registros
  Future<int> deleteScan(int id) async {
    final db = await database;
    //Cuidado si no ponemos el where borramos toda la tabla
    final res = await db.delete('Scans', where: 'id=?', whereArgs: [id] );
    return res;
  }
  //Borramos todos los registros
  Future<int> deleteAll() async {
    final db = await database;
    //Cuidado si no ponemos el where borramos toda la tabla
    final res = await db.rawUpdate('DELETE FROM Scans');
    return res;
  }



}