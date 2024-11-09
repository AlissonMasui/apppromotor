// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Diario {

String id_diario;
String titulo;
String texto;
String data;
String id_revenda;

Diario({
required this.id_diario,
  required this.titulo,
  required this.texto,
  required this.data,
  required this.id_revenda

});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Id_diario': id_diario,
      'Titulo': titulo,
      'Text': texto,
      'Data': data,
      'Id_revenda': id_revenda,
    };
  }

  factory Diario.fromMap(Map<String, dynamic> map) {
    return Diario(
      id_diario: map['Id_diario'] as String,
      titulo: map['Titulo'] as String,
      texto: map['Text'] as String,
      data: map['Data'] as String,
      id_revenda: map['Id_revenda'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Diario.fromJson(String source) => Diario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Diario(Id_diario: $id_diario, Titulo: $titulo, Text: $texto, Data: $data, Id_revenda: $id_revenda)';
  }
}
