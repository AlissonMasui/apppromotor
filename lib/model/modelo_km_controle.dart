import 'dart:convert';

class KmControle {

    String idKmControle;
    String kmInicial;
    String idPromotor;
    String idVeiculo;
    String destino;
    String data;
    String posicao;


KmControle({
required this.idKmControle,
required this.kmInicial,
required this.idPromotor,
required this.idVeiculo,
required this.destino,
required this.data,
required this.posicao,

});


Map<String, dynamic> toMap(){
  return <String, dynamic>{
    'idKmControle' :idKmControle,
    'kmInicial' : kmInicial,
    'idPromotor' : idPromotor,
    'idVeiculo' : idVeiculo,
    'destino' : destino,
    'data' : data,
    'posicao' : posicao,
  };
}
    factory KmControle.fromMap(Map<String, dynamic> map) {
        return KmControle(
          idKmControle:  map['idKmControle'] as String, 
          kmInicial: map['kmInicial'] as String, 
          idPromotor: map['idPromotor'] as String, 
          idVeiculo: map['idVeiculo'] as String, 
          destino: map['destino'] as String, 
          data: map['data'] as String, 
          posicao: map['posicao'] as String,
          );

    }
String toJson() => json.encode(toMap());

factory KmControle.fromJson(String source)=> KmControle.fromMap(json.decode(source) as Map<String, dynamic>);
}