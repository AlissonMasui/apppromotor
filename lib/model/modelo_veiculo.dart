// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Veiculo {
  String idVeiculo;
  String modelo;
  String marca;
  String placa;
  String revisao;
  String kmAtual;

  Veiculo({
    required this.idVeiculo,
    required this.modelo,
    required this.marca,
    required this.placa,
    required this.revisao,
    required this.kmAtual,
    });






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

  factory Veiculo.fromMap(Map<String, dynamic> map) {
    return Veiculo(
      idVeiculo: map['id_veiculo'] as String,
      modelo: map['modelo'] as String,
      marca: map['marca'] as String,
      placa: map['placa'] as String,
      revisao: map['revisao'] as String,
      kmAtual: map['kmAtual'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Veiculo.fromJson(String source) => Veiculo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Veiculo(id_veiculo: $idVeiculo, modelo: $modelo, marca: $marca, placa: $placa, revisao: $revisao, kmAtual: $kmAtual)';
  }
}
