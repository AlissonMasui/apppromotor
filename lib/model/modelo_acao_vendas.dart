class AcaoVendas{

int id_acao_vendas;
int id_revenda;
int id_promotor;
DateTime dataAcao;
String? Proposito;
String? Propositos_alcansados;
List<int>? id_imagem;

AcaoVendas({
  required this.id_acao_vendas,
  required this.id_revenda,
  required this.id_promotor,
  required this.dataAcao,
  this.Proposito,
  this.Propositos_alcansados,
  this.id_imagem,
}
);



}
