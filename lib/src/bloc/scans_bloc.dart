


import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validators {
  //Vamos a usar un patron Singleton
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    // Obtener scans de la base de datos, vamos a obtener todos
    obtenerScans();
  }

  //Para crear un Stream ocupamos un stream controller, 
  //lo usamos de tipo broadcast porque varios van a esta escuchando
  final _scansController = StreamController<List<ScanModel>>.broadcast();

  //Ocupamos poder escuchar la informacion que fluye a travez del mismo.
  //Podemos especificar la información que vamos a escuchar
  Stream<List<ScanModel>> get scansStream     => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);

  //Cuando se crea un StreamController debemos cerrar las instancias del mismo
  //Es importante poner el signo de interrogación porque si no tuviera ningun objeto fallaria
  dispose(){
    _scansController?.close();
  }

  

  //Usualmente se acostumbra a ponerlo en otra archivo independiente llamado Events, para que el bloc sea sencillo
  obtenerScans() async {
    // El DBProvider es un future, por ese motivo podemos esperarlo con el await
    _scansController.sink.add( await DBProvider.db.getTodosScans());
  }


  agregarScan(ScanModel scan) async {
    //Agregamos el nuevo registro y es posible que pueda demorar, por esos el await
    await DBProvider.db.nuevoScan(scan);
    //Llamamos todos los registros para que se dibuje en pantalla el nuevo registro
    obtenerScans();
  }

  // El borrar un Scan va a necesitar el id, por este motivo debemos de pedirlo
  borrarScan(int id) async {

    //Esta instancia tambien regresa un Future, por lo que debemos de usar un await y por ende un async
    await DBProvider.db.deleteScan(id);
    //Volvemos a traer toda la lista para que la pantalla muestre el cambio.
    obtenerScans();
  }

  borrarScanTODOS() async {
    //Borramos todos los scans
    await DBProvider.db.deleteAll();
    //Volvemos a cargar el metodo que trae todos para que muestre el borrado
    obtenerScans();
  }





}