// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Diario {

String idDiario;
String titulo;
String texto;
String data;
String idRevenda;

Diario({
required this.idDiario,
  required this.titulo,
  required this.texto,
  required this.data,
  required this.idRevenda

});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Id_diario': idDiario,
      'Titulo': titulo,
      'Text': texto,
      'Data': data,
      'Id_revenda': idRevenda,
    };
  }

  factory Diario.fromMap(Map<String, dynamic> map) {
    return Diario(
      idDiario: map['Id_diario'] as String,
      titulo: map['Titulo'] as String,
      texto: map['Text'] as String,
      data: map['Data'] as String,
      idRevenda: map['Id_revenda'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Diario.fromJson(String source) => Diario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Diario(Id_diario: $idDiario, Titulo: $titulo, Text: $texto, Data: $data, Id_revenda: $idRevenda)';
  }
}
