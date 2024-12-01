import 'package:apppromotor/model/modelo_acao_Vendas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../model/modeloRevenda.dart';

String uid = FirebaseAuth.instance.currentUser!.uid;
String name = FirebaseAuth.instance.currentUser!.displayName!;

class ControleAcaoVendas extends StatefulWidget {
  const ControleAcaoVendas({super.key});

  @override
  State<ControleAcaoVendas> createState() => _ControleRevendaState();
}

class _ControleRevendaState extends State<ControleAcaoVendas> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<AcaoVendas> listAcaoVendas = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  ValueNotifier<List<Revenda>> listRevenda = ValueNotifier([]);
  ValueNotifier<String> selected = ValueNotifier("");

  @override
  void initState() {
    refresh();
    super.initState();
    buscaRevenda();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Acão de Vendas'),
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
                          Text(acaoVendasM.idRevenda,
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
                            acaoVendasM.proposito.toString(),
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
    String labelTitle = "Controle de Ação de vendas";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    // Controlador do campo que receberá o nome do Campo
    TextEditingController idController = TextEditingController();
    TextEditingController dataAcaoController = TextEditingController();
    dataAcaoController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    TextEditingController propositoController = TextEditingController();
    TextEditingController propositoAlcansadosController =
        TextEditingController();
    TextEditingController idPromotorController = TextEditingController();
    idPromotorController.text = name;
    TextEditingController idrevendaController = TextEditingController();

    if (model != null) {
      labelTitle = "Editando Registro de Revenda";
      idController.text = model.idAcaoVendas;
      propositoController.text = model.proposito;
      dataAcaoController.text = model.dataAcao;
      model.propositosAlcansados ??= "Não a propositos alcançados";
      propositoAlcansadosController.text = model.propositosAlcansados!;
      idrevendaController.text = model.idRevenda;

      idPromotorController.text = model.idPromotor;
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
              ValueListenableBuilder<List<Revenda>>(
                valueListenable: listRevenda,
                builder: (context, revendas, _) {
                  if (revendas.isEmpty) {
                    return Container();
                  }
                  return ValueListenableBuilder(
                    valueListenable: selected,
                    builder: (context, selectedValue, _) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Cor da borda
                            width: 1.0, // Espessura da borda
                          ),
                          borderRadius:
                              BorderRadius.circular(8.0), // Bordas arredondadas
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButton<String>(
                          value: idrevendaController.text.isEmpty
                              ? null
                              : idrevendaController.text,
                          hint: const Text('Selecione a revenda'),
                          isExpanded: true,
                          underline: const SizedBox(), // Remove a linha padrão
                          items: revendas.map((Revenda revenda) {
                            return DropdownMenuItem<String>(
                              value: revenda.id_revenda,
                              child: Text(revenda.nome),
                            );
                          }).toList(),
                          onChanged: (String? novoValor) {
                            idrevendaController.text = novoValor ?? '';
                            selected.value = novoValor ?? '';
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              TextFormField(
                controller: propositoController,
                decoration: const InputDecoration(
                    label: Text("Proposito Ação de vendas")),
              ),
              TextField(
                controller: dataAcaoController,
                decoration: const InputDecoration(
                  label: Text("Selecione a Data"),
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    setState(() {
                      dataAcaoController.text =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                    });
                  }
                },
              ),
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
                        idAcaoVendas: Uuid().v1(),
                        idRevenda: idrevendaController.text,
                        idPromotor: name,
                        dataAcao: dataAcaoController.text,
                        proposito: propositoController.text,
                      );

                      if (model != null) {
                        newAcaoVendas.idAcaoVendas = model.idAcaoVendas;
                      }

                      db
                          .collection('usuario/$uid/acaoVendas')
                          .doc(newAcaoVendas.idAcaoVendas)
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
        await db.collection('usuario/$uid/acaoVendas').get();

    for (var doc in snapshot.docs) {
      temp.add(AcaoVendas.fromMap(doc.data()));
    }
    setState(() {
      listAcaoVendas = temp;
    });
  }

  void remove(AcaoVendas acaoVendasM) {
    db
        .collection('usuario/$uid/acaoVendas')
        .doc(acaoVendasM.idRevenda)
        .delete();
    refresh();
  }

  // Future<DateTime?> selectData() async {
  //   DateTime? _selected = await showDatePicker(
  //     context: context,
  //     firstDate: DateTime(2022),
  //     lastDate: DateTime(2050),
  //     initialDate: DateTime.now(),
  //
  //   );
  //   return _selected;
  // }
  buscaRevenda() async {
    List<Revenda> revendas = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection('usuario/$uid/revenda').get();

    for (var doc in snapshot.docs) {
      revendas.add(Revenda.fromMap(doc.data()));
    }
    listRevenda.value = revendas;
  }
}
