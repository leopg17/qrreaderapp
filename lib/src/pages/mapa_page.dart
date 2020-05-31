import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

class MapaPage extends StatelessWidget {

  final map = MapController();
  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: (){
              map.move(scan.getLatLng(), 10);
            }
          )
        ],
      ),
      body: _crearFlutterMap(scan)
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
      additionalOptions: {
      'accessToken':'pk.eyJ1IjoibGVvcGcxNyIsImEiOiJja2F0OGlqemkwOXFiMzFwaGdwM21kNnFlIn0.ee-xwoq7cAwJPxGOVKWnzA',
      'id': 'mapbox/satellite-streets-v11',
      // tipos de mapas mapbox://styles/mapbox/streets-v11
      // tipos de mapas mapbox://styles/mapbox/outdoors-v11
      // tipos de mapas mapbox://styles/mapbox/light-v10
      // tipos de mapas mapbox://styles/mapbox/dark-v10
      // tipos de mapas mapbox://styles/mapbox/satellite-v9
      // tipos de mapas mapbox://styles/mapbox/satellite-streets-v11
      }
    );
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          //Dibujo nuevamente en pantalla
          builder: (context) => Container(
            child: Icon(
              Icons.location_on,
              size: 45.0,
              color: Theme.of(context).primaryColor,)
          ),
        ),
      ]
    );
  }
}