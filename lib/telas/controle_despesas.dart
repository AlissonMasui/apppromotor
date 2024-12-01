import 'package:apppromotor/model/modelo_despesa.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../model/modelo_veiculo.dart';

class ControleDespesa extends StatefulWidget {
  const ControleDespesa({super.key});

  @override
  State<ControleDespesa> createState() => _ControleDespesasState();
}

class _ControleDespesasState extends State<ControleDespesa> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<Despesa> listDespesa = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  ValueNotifier<List<Veiculo>> listVeiculos = ValueNotifier([]);
  ValueNotifier<String?> selected = ValueNotifier(null);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    buscaVeiculo();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Despesas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : listDespesa.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhum registro ainda.\nVamos criar o primeiro?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                    itemCount: listDespesa.length,
                    itemBuilder: (context, index) {
                      Despesa despesa = listDespesa[index];
                      return Card(
                        child: Dismissible(
                          key: ValueKey(despesa.idDespesa),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 8.0),
                            color: Colors.red,
                            child: const Icon(Icons.delete),
                          ),
                          onDismissed: (direction) {
                            remove(despesa);
                          },
                          child: ListTile(
                            onTap: () {},
                            onLongPress: () {
                              showFormModal(model: despesa);
                            },
                            title: Row(
                              children: [
                                const Text("Número NF: ",
                                    style: TextStyle(fontSize: 16.0)),
                                Text(despesa.numeroNf,
                                    style: const TextStyle(fontSize: 16.0)),
                              ],
                            ),
                            subtitle: Text(despesa.quando,
                                style: const TextStyle(fontSize: 14.0)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Future<void> showFormModal({Despesa? model}) async {
    await buscaVeiculo();
    setState(() => isLoading = true);

    String labelTitle = model == null
        ? "Registro de Despesas"
        : "Editando Registro de Despesas";
    String labelConfirmationButton = model == null ? "Salvar" : "Atualizar";

    TextEditingController numeroNfController = TextEditingController();
    TextEditingController oQueController = TextEditingController();
    TextEditingController ondeController = TextEditingController();
    TextEditingController quandoController = TextEditingController();
    TextEditingController precoController = TextEditingController();
    TextEditingController kmController = TextEditingController();
    TextEditingController idVeiculoController = TextEditingController();

    quandoController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());

//     if (model != null) {
//       numeroNfController.text = model.numeroNf;
//       oQueController.text = model.oQue;
//       ondeController.text = model.onde;
//       quandoController.text = model.quando;
//       precoController.text = model.preco;
//       kmController.text = model.km;
//       idVeiculoController.text = model.idVeiculo ?? "";
//       selected.value = model.idVeiculo;
//     }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(labelTitle, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              TextFormField(
                controller: numeroNfController,
                decoration: const InputDecoration(
                    labelText: "Digite o número da Nota Fiscal"),
              ),
              TextFormField(
                controller: oQueController,
                decoration: const InputDecoration(
                    labelText: "Digite o tipo de despesa"),
              ),
              TextFormField(
                controller: ondeController,
                decoration: const InputDecoration(labelText: "Local:"),
              ),
              TextFormField(
                controller: quandoController,
                decoration: const InputDecoration(
                  labelText: "Data",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    quandoController.text =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                  }
                },
              ),
              TextFormField(
                controller: precoController,
                decoration: const InputDecoration(labelText: "Preço"),
              ),
              TextFormField(
                controller: kmController,
                decoration: const InputDecoration(labelText: "Quilometragem"),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<List<Veiculo>>(
                valueListenable: listVeiculos,
                builder: (context, veiculos, _) {
                  return DropdownButtonFormField<String>(
                    value: selected.value,
                    decoration: const InputDecoration(
                        labelText: "Selecione o Veículo"),
                    items: veiculos.map((veiculo) {
                      return DropdownMenuItem<String>(
                        value: veiculo.idVeiculo,
                        child: Text("${veiculo.modelo} (Placa: ${veiculo.placa})"),
                      );
                    }).toList(),
                    onChanged: (String? novoValor) {
                      selected.value = novoValor;
                      idVeiculoController.text = novoValor ?? '';
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Despesa novaDespesa = Despesa(
                        idDespesa: model?.idDespesa ?? Uuid().v1(),
                        numeroNf: numeroNfController.text,
                        oQue: oQueController.text,
                        onde: ondeController.text,
                        quando: quandoController.text,
                        preco: precoController.text,
                        km: kmController.text,
                        idVeiculo: idVeiculoController.text,
                      );

                      db
                          .collection('usuario/$uid/despesa')
                          .doc(novaDespesa.idDespesa)
                          .set(novaDespesa.toMap())
                          .then((_) => refresh());
                      Navigator.pop(context);
                    },
                    child: Text(labelConfirmationButton),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    setState(() => isLoading = false);
  }

  Future<void> refresh() async {
    List<Despesa> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection('usuario/$uid/despesa').get();
    for (var doc in snapshot.docs) {
      temp.add(Despesa.fromMap(doc.data()));
    }
    setState(() {
      listDespesa = temp;
      isLoading = false;
    });
  }

  Future<void> buscaVeiculo() async {
    List<Veiculo> veiculos = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection('usuario/$uid/veiculo').get();
    for (var doc in snapshot.docs) {
      veiculos.add(Veiculo.fromMap(doc.data()));
    }
    listVeiculos.value = veiculos;
  }

  void remove(Despesa despesa) {
    db.collection('usuario/$uid/despesa').doc(despesa.idDespesa).delete();
    refresh();
  }
}
