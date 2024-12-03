class Imagens {
  String id_imagen ;
  String id_origen ;
  String url;
  String data ;


  Imagens({
   required this.id_imagen;
   required this.id_origen;
   required this.url;
   required this.data;
   });

Map<String, dynamic> toMap(){
  return <String, dynamic>{
    'id_imagen' : id_imagen,
    'id_origen' : id_origen,
    'url' : url,
    'data': data,

  }
}


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_veiculo': idVeiculo,
      'modelo': modelo,
      'marca': marca,
      'placa': placa,
      'revisao': revisao,
      'kmAtual': kmAtual,
    };
  }





}