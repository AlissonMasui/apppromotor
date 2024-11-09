// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Revenda {

  String id_revenda;
  String nome;
  String cnpj;
  String nomeDonoGerente;
  String foneDonoGerente;
  String dataNacimentoDono;
  String nomeComprador;
  String foneComprador;
  String dataNacimentoComprador;

Revenda({
  required this.id_revenda,
  required this.cnpj,
  required this.nome,
  required this.nomeDonoGerente,
  required this.foneDonoGerente,
  required this.dataNacimentoDono,
  required this.nomeComprador,
  required this.foneComprador,
  required this.dataNacimentoComprador,
});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_revenda': id_revenda,
      'nome': nome,
      'cnpj': cnpj,
      'nomeDonoGerente': nomeDonoGerente,
      'foneDonoGerente': foneDonoGerente,
      'dataNacimentoDono': dataNacimentoDono,
      'nomeComprador': nomeComprador,
      'foneComprador': foneComprador,
      'dataNacimentoComprador': dataNacimentoComprador,
    };
  }

  factory Revenda.fromMap(Map<String, dynamic> map) {
    return Revenda(
      id_revenda: map['id_revenda'] as String,
      nome: map['nome'] as String,
      cnpj: map['cnpj'] as String,
      nomeDonoGerente: map['nomeDonoGerente'] as String,
      foneDonoGerente: map['foneDonoGerente'] as String,
      dataNacimentoDono: map['dataNacimentoDono'] as String,
      nomeComprador: map['nomeComprador'] as String,
      foneComprador: map['foneComprador'] as String,
      dataNacimentoComprador: map['dataNacimentoComprador'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Revenda.fromJson(String source) => Revenda.fromMap(json.decode(source) as Map<String, dynamic>);
}
