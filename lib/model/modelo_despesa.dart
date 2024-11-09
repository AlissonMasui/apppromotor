// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Despesa {

    String idDespesa;
    String numeroNf;
    String oQue;
    String onde;
    String quando;
    String preco;
    String km;
    String placa;
    String idImagem;


    Despesa({
     required this.idDespesa,
     required this.numeroNf,
     required this.oQue,
     required this.onde,
     required this.quando,
     required this.preco,
     required this.km,
     required this.placa,
     required this.idImagem,  
    }
      );


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_despesa': idDespesa,
      'numeroNf': numeroNf,
      'oQue': oQue,
      'onde': onde,
      'quando': quando,
      'preco': preco,
      'km': km,
      'placa': placa,
      'id_imagem': idImagem,
    };
  }

  factory Despesa.fromMap(Map<String, dynamic> map) {
    return Despesa(
      idDespesa: map['id_despesa'] as String,
      numeroNf: map['numeroNf'] as String,
      oQue: map['oQue'] as String,
      onde: map['onde'] as String,
      quando: map['quando'] as String,
      preco: map['preco'] as String,
      km: map['km'] as String,
      placa: map['placa'] as String,
      idImagem: map['id_imagem'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Despesa.fromJson(String source) => Despesa.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Despesa(id_despesa: $idDespesa, numeroNf: $numeroNf, oQue: $oQue, onde: $onde, quando: $quando, preco: $preco, km: $km, placa: $placa, id_imagem: $idImagem)';
  }
}