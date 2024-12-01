import 'package:apppromotor/model/ModeloDiarioCampo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../authentication/components/show_snackbar.dart';
import '../model/modeloRevenda.dart';

class DiarioDeCampo extends StatefulWidget {
  const DiarioDeCampo({super.key});

  @override
  State<DiarioDeCampo> createState() => _DiarioDeCampoState();
}

class _DiarioDeCampoState extends State<DiarioDeCampo> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String name = FirebaseAuth.instance.currentUser!.displayName!;
  List<Diario> listDiario = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  ValueNotifier<List<Revenda>> listRevendas = ValueNotifier([]);
  ValueNotifier<String> selected = ValueNotifier("");
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    buscaRevenda();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diario de campo'),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showFormModal();
            },
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              showSnackBar(mensagem: 'click Exportar', context: context);
            },
            child: const Icon(Icons.import_export),
          ),
        ],
      ),
      body: isLoading // Verifica se está carregando
          ? const Center(child: CircularProgressIndicator()) // Exibe o loading
          : (listDiario.isEmpty)
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
                    children: List.generate(listDiario.length, (index) {
                      Diario diarioM = listDiario[index];
                      return Card(
                          child: Dismissible(
                        key: ValueKey<Diario>(diarioM),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 8.0),
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        onDismissed: (diretion) {
                          remove(diarioM);
                        },
                        child: ListTile(
                          onTap: () {},
                          onLongPress: () {
                            showFormModal(model: diarioM);
                          },
                          title: Row(
                            children: [
                              const Text("Titulo:",
                                  style: TextStyle(fontSize: 24.0)),
                              Text(diarioM.titulo,
                                  style: const TextStyle(fontSize: 24.0)),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(diarioM.data,
                                  style: const TextStyle(fontSize: 16.0)),
                            ],
                          ),
                        ),
                      ));
                    }),
                  ),
                ),
    );
  }

  showFormModal({Diario? model}) async {
    setState(() {
      isLoading = true; // Inicia o carregamento ao abrir o modal
    });

    String labelTitle = "Registrar Diario";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    TextEditingController tituloController = TextEditingController();
    TextEditingController textocontroller = TextEditingController();
    TextEditingController dataController = TextEditingController();
    dataController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    TextEditingController idRevendaController = TextEditingController();

    if (model != null) {
      labelTitle = "Editando Diario de campo";
      tituloController.text = model.titulo;
      textocontroller.text = model.texto;
      dataController.text = model.data;
      idRevendaController.text = model.idRevenda;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32.0),
          child: ListView(
            children: [
              Text(labelTitle),
              TextFormField(
                controller: tituloController,
                decoration:
                    const InputDecoration(label: Text("Digite o titulo:")),
              ),
              TextFormField(
                controller: textocontroller,
                decoration: const InputDecoration(
                    label: Text("Digite aqui como foi o dia:")),
              ),
              TextField(
                controller: dataController,
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
                      dataController.text =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                    });
                  }
                },
              ),
              ValueListenableBuilder<List<Revenda>>(
                valueListenable: listRevendas,
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
                          value: idRevendaController.text.isEmpty
                              ? null
                              : idRevendaController.text,
                          hint: const Text('Selecione uma Revenda'),
                          isExpanded: true,
                          underline: const SizedBox(),
                          // Remove a linha padrão
                          items: revendas.map((Revenda revenda) {
                            return DropdownMenuItem<String>(
                              value: revenda.id_revenda,
                              child: Text(revenda.nome),
                            );
                          }).toList(),
                          onChanged: (String? novoValor) {
                            idRevendaController.text = novoValor ?? '';
                            selected.value = novoValor ?? '';
                          },
                        ),
                      );
                    },
                  );
                },
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
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Text(labelSkipButton),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Diario newDiario = Diario(
                        idDiario: Uuid().v1(),
                        titulo: tituloController.text,
                        texto: textocontroller.text,
                        data: dataController.text,
                        idRevenda: idRevendaController.text,
                      );
                      if (model != null) {
                        newDiario.idDiario = model.idDiario;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      db
                          .collection('usuario/$uid/diario')
                          .doc(newDiario.idDiario)
                          .set(newDiario.toMap())
                          .then((value) {
                        refresh();
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context);
                      });
                      setState(() {
                        isLoading = false;
                      });
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
    List<Diario> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection('usuario/$uid/diario').get();

    for (var doc in snapshot.docs) {
      temp.add(Diario.fromMap(doc.data()));
    }
    setState(() {
      listDiario = temp;
      isLoading = false;
    });
  }

  buscaRevenda() async {
    List<Revenda> revendas = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection('usuario/$uid/revenda').get();

    for (var doc in snapshot.docs) {
      revendas.add(Revenda.fromMap(doc.data()));
    }
    listRevendas.value = revendas;
  }

  remove(Diario diarioM) {
    db.collection('usuario/$uid/diario').doc(diarioM.idDiario).delete();
    refresh();
  }
}
