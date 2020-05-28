import 'package:flutter/material.dart';


import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
//import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
//No debemos de utilizar el DB Provider aca, esto para centralizar toda la información
//y que se notifique correctamente, DBProvider solo va a ser accedida mediante el Bloc
//mport 'package:qrreaderapp/src/providers/db_provider.dart';

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
            onPressed: (){
              scansBloc.borrarScanTODOS();
            },
            
          )
        ]
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: _scanQR,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      
    );
  }

  _scanQR() async {

    //http://bolsacr.com/

    //geo:10.04692358476945,-84.32874992331394
    dynamic futureString = 'geo:10.04692358476945,-84.32874992331394';
    

    // try {
    //   futureString = await BarcodeScanner.scan();

    // }catch( e ) {
    //   futureString = e.toString();
    // }

    // print('Future String: ${futureString.rawContent}'); // Esto nos ayuda a depurarlo en caso de error especial

    if(futureString != null){
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);
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