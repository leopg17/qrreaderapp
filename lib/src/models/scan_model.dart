import 'package:latlong/latlong.dart';

class ScanModel {
    int id;
    String tipo;
    String valor;

    ScanModel({
        this.id,
        this.tipo,
        this.valor,
    }){
      if(valor.contains('http')){
        this.tipo = 'http';
      }else {
        this.tipo = 'geo';
      }
    }

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
    };

    LatLng getLatLng(){
      // El substring 4, lo que me permite es ignorar los 4 caracteres iniciales.
      // de la siguiente linea ignora geo:
      //geo:10.04692358476945,-84.32874992331394
      final lalo = valor.substring(4).split(',');
      final lat = double.parse(lalo[0]);
      final lng = double.parse(lalo[1]);
      return LatLng(lat,lng);
    }
}
