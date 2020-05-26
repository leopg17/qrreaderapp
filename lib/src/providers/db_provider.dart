import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  
  static Database _database;
  // Constructor privado
  static final DBProvider db = DBProvider._(); 

  DBProvider._();

  Future <Database> get database async{
    //Consultamos si ya existe la base de datos
    if (_database != null) return _database;
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
}