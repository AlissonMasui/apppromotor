import 'dart:convert';

class Imagen {

  String idImagen;
  String idVinculo;
  String data;
  String url;

  Imagen({
    required this.idImagen,
    required this.idVinculo,
    required this.data,
    required this.url,

  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idImagen': idImagen,
      'idVinculo': idVinculo,
      'data': data,
      'url': url,
    };
  }

  factory Imagen.fromMap(Map<String, dynamic> map) {
    return Imagen(
      idImagen: map['idImagen'] as String,
      idVinculo: map['idVinculo'] as String,
      data: map['data'] as String,
      url: map['url'] as String,
      );
  }

  String toJson() => json.encode(toMap());

  factory Imagen.fromJson(String source) =>
      Imagen.fromMap(json.decode(source) as Map<String, dynamic>);

}