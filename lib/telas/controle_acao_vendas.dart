import 'package:apppromotor/model/modelo_acao_vendas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ControleAcaoVendas extends StatefulWidget {
  const ControleAcaoVendas({super.key});

  @override
  State<ControleAcaoVendas> createState() => _ControleRevendaState();
}

class _ControleRevendaState extends State<ControleAcaoVendas> {
  List<AcaoVendas> listAcaoVendas = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Revendas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistroKM(),),);
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: (listAcaoVendas.isEmpty)
          ? const Center(
              child: Text(
                "Nenhuma Registro ainda.\nVamos criar o primeiro?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: ListView(
                children: List.generate(listAcaoVendas.length, (index) {
                  AcaoVendas acaoVendasM = listAcaoVendas[index];
                  return Card(
                      child: Dismissible(
                    key: ValueKey<AcaoVendas>(acaoVendasM),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 8.0),
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    onDismissed: (diretion) {
                      remove(acaoVendasM);
                    },
                    child: ListTile(
                      onTap: () {
                        //print("Click");
                      },
                      onLongPress: () {
                        showFormModal(model: acaoVendasM);

                        //print("CLick e segurou");
                      },
                      title: Row(
                        children: [
                          const Text("Revenda :",
                              style: TextStyle(fontSize: 24.0)),
                          Text(acaoVendasM.id_revenda,
                              style: const TextStyle(fontSize: 24.0)),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            acaoVendasM.dataAcao.toString(),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            acaoVendasM.Proposito.toString(),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ));
                }),
              ),
            ),
    );
  }

  showFormModal({AcaoVendas? model}) {
    // Labels à serem mostradas no Modal
    String labelTitle = "Registrar Revenda";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    // Controlador do campo que receberá o nome do Campo
    TextEditingController idController = TextEditingController();
    TextEditingController dataAcaoController = TextEditingController();
    TextEditingController propositoController = TextEditingController();
    TextEditingController propositoAlcansadosController =TextEditingController();
    TextEditingController idPromotorController = TextEditingController();
    TextEditingController idrevendaController = TextEditingController();

    if (model != null) {
      labelTitle = "Editando Registro de Revenda";
      idController.text = model.id_acao_vendas;
      propositoController.text = model.Proposito;
      dataAcaoController.text = model.dataAcao;
      if (model.Propositos_alcansados == null) {
        model.Propositos_alcansados = "Não a propositos alcançados";
      }
      propositoAlcansadosController.text = model.Propositos_alcansados!;
      idrevendaController.text = model.id_revenda;

      ;

      idPromotorController.text = model.id_promotor;
    }

    // Função do Flutter que mostra o modal na tela
    showModalBottomSheet(
      context: context,

      // Define que as bordas verticais serão arredondadas
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32.0),

          // Formulário com Título, Campo e Botões
          child: ListView(
            children: [
              Text(labelTitle),
              TextFormField(
                controller: idrevendaController,
                decoration:
                    const InputDecoration(label: Text("Nome da Revenda:")),
              ),
              TextFormField(
                controller: propositoController,
                decoration: const InputDecoration(
                    label: Text("Proposito Ação de vendas")),
              ),

              // TextFormField(
              //   controller: dataAcaoController,

              //   decoration:
              //       const InputDecoration(label: Text("data de realização da ação de vendas ")),
              // ),
              
              TextFormField(
                controller: idPromotorController,
                decoration:
                    const InputDecoration(label: Text("Promotort de vendas")),
              ),
              TextFormField(
                controller: propositoAlcansadosController,
                decoration: const InputDecoration(
                    label: Text("Breve texto dos objetivos alcançados")),
              ),

              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(labelSkipButton),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      AcaoVendas newAcaoVendas = AcaoVendas(
                        id_acao_vendas: Uuid().v1(),
                        id_revenda: idrevendaController.text,
                        id_promotor: idPromotorController.text,
                        dataAcao: dataAcaoController.text,
                        Proposito: propositoController.text,
                      );

                      if (model != null) {
                        newAcaoVendas.id_revenda = model.id_revenda;
                      }

                      db
                          .collection('acaovendas')
                          .doc(newAcaoVendas.id_revenda)
                          .set(newAcaoVendas.toMap());
                      refresh();
                      Navigator.pop(context);
                    },
                    child: Text(labelConfirmationButton),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  refresh() async {
    List<AcaoVendas> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection("revenda").get();

    for (var doc in snapshot.docs) {
      temp.add(AcaoVendas.fromMap(doc.data()));
    }
    setState(() {
      listAcaoVendas = temp;
    });
  }

  void remove(AcaoVendas acaoVendasM) {
    db.collection("acaoVendas").doc(acaoVendasM.id_revenda).delete();
    refresh();
  }

  Future<DateTime?> selectData() async {
    DateTime? _selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
      
    );
    return _selected;
  }
}
