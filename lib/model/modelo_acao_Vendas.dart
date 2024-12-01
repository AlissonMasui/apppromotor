// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AcaoVendas {

String idAcaoVendas;
String idRevenda;
String idPromotor;
String dataAcao;
String proposito;
String? propositosAlcansados;

AcaoVendas({
  required this.idAcaoVendas,
  required this.idRevenda,
  required this.idPromotor,
  required this.dataAcao,
  required this.proposito,
  this.propositosAlcansados,
}
);




  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_acao_vendas': idAcaoVendas,
      'id_revenda': idRevenda,
      'id_promotor': idPromotor,
      'dataAcao': dataAcao,
      'Proposito': proposito,
      'Propositos_alcansados': propositosAlcansados,
    };
  }

  factory AcaoVendas.fromMap(Map<String, dynamic> map) {
    return AcaoVendas(
      idAcaoVendas: map['id_acao_vendas'] as String,
      idRevenda: map['id_revenda'] as String,
      idPromotor: map['id_promotor'] as String,
      dataAcao: map['dataAcao'] as String,
      proposito: map['Proposito'] as String ,
      propositosAlcansados: map['Propositos_alcansados'] != null ? map['Propositos_alcansados'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AcaoVendas.fromJson(String source) => AcaoVendas.fromMap(json.decode(source) as Map<String, dynamic>);
}
