import 'dart:io';

import 'package:flutter/material.dart';


import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
//import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';


import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
//En la linea de abajo se ve como le podemos poner un alias
//No debemos de utilizar el DB Provider aca, esto para centralizar toda la información
//y que se notifique correctamente, DBProvider solo va a ser accedida mediante el Bloc
//import 'package:qrreaderapp/src/providers/db_provider.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScanTODOS,
            
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      
    );
  }

  _scanQR(BuildContext context) async {

    //http://bolsacr.com/

    //geo:10.04692358476945,-84.32874992331394
    dynamic futureString = '';
    

    try {
      futureString = await BarcodeScanner.scan();

    }catch( e ) {
      futureString = e.toString();
    }

    print('Future String: ${futureString.rawContent}'); // Esto nos ayuda a depurarlo en caso de error especial

    if(futureString != null){
      final scan = ScanModel( valor: futureString.rawContent );
      scansBloc.agregarScan(scan);

      // final scan2 = ScanModel(valor: 'geo:10.04692358476945,-84.32874992331394');
      // scansBloc.agregarScan(scan2);


      //Como estaba dando un error en IOS se agrego esta linea
      //Estamos haciendo una demora para esperar a que la animación de la camara se cierre
      if ( Platform.isIOS ){
        Future.delayed(Duration(milliseconds: 750), (){
          utils.abrirScan(context, scan);
        }); 
      } else {
        utils.abrirScan(context, scan);
      }

      
    }
  }


  Widget _callPage(int paginaActual){
    switch(paginaActual){
      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default:
        return MapasPage();
    }
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ],
    );
  }
}