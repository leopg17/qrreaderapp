//Archivo para copiar metodos y funciones
import 'package:url_launcher/url_launcher.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

abrirScan( ScanModel scan) async {
  //Tenemos que hacer unas validaciones porque vamos a abrir de geolocation y http

  if (scan.tipo == 'http'){
    if (await canLaunch(scan.valor)) {
    await launch(scan.valor);
    } else {
    throw 'Could not launch ${ scan.valor }';
    }

  }else {
    print('GEO...');
  }
  
}