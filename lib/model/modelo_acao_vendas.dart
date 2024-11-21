// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AcaoVendas {

String id_acao_vendas;
String id_revenda;
String id_promotor;
String dataAcao;
String Proposito;
String? Propositos_alcansados;

AcaoVendas({
  required this.id_acao_vendas,
  required this.id_revenda,
  required this.id_promotor,
  required this.dataAcao,
  required this.Proposito,
  this.Propositos_alcansados,
}
);




  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_acao_vendas': id_acao_vendas,
      'id_revenda': id_revenda,
      'id_promotor': id_promotor,
      'dataAcao': dataAcao,
      'Proposito': Proposito,
      'Propositos_alcansados': Propositos_alcansados,
    };
  }

  factory AcaoVendas.fromMap(Map<String, dynamic> map) {
    return AcaoVendas(
      id_acao_vendas: map['id_acao_vendas'] as String,
      id_revenda: map['id_revenda'] as String,
      id_promotor: map['id_promotor'] as String,
      dataAcao: map['dataAcao'] as String,
      Proposito: map['Proposito'] as String ,
      Propositos_alcansados: map['Propositos_alcansados'] != null ? map['Propositos_alcansados'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AcaoVendas.fromJson(String source) => AcaoVendas.fromMap(json.decode(source) as Map<String, dynamic>);
}
