import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../../model/modelo_km_controle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../model/modelo_veiculo.dart';

class ControleKm extends StatefulWidget {
  const ControleKm({super.key});

  @override
  State<ControleKm> createState() => _ControleKmState();
}

class _ControleKmState extends State<ControleKm> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String name = FirebaseAuth.instance.currentUser!.displayName!;
  List<KmControle> listKmControle = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  ValueNotifier<Position?> posicaoAtual = ValueNotifier(null);
  ValueNotifier<List<Veiculo>> listVeiculos = ValueNotifier([]);
  ValueNotifier<String> selected = ValueNotifier("");
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getLocalidade();
    buscaVeiculo();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle kilometragem'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading // Verifica se está carregando
          ? const Center(child: CircularProgressIndicator()) // Exibe o loading
          : (listKmControle.isEmpty)
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
                    children: List.generate(listKmControle.length, (index) {
                      KmControle kmControleM = listKmControle[index];
                      return Card(
                          child: Dismissible(
                        key: ValueKey<KmControle>(kmControleM),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 8.0),
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        onDismissed: (diretion) {
                          remove(kmControleM);
                        },
                        child: ListTile(
                          onTap: () {},
                          onLongPress: () {
                            showFormModal(model: kmControleM);
                          },
                          title: Row(
                            children: [
                              const Text("KmInicial :",
                                  style: TextStyle(fontSize: 24.0)),
                              Text(kmControleM.kmInicial,
                                  style: const TextStyle(fontSize: 24.0)),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(kmControleM.destino,
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

  showFormModal({KmControle? model}) async {
    setState(() {
      isLoading = true; // Inicia o carregamento ao abrir o modal
    });

    String labelTitle = "Registrar KM";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    TextEditingController kmInicialController = TextEditingController();
    TextEditingController idPromotorController = TextEditingController();
    idPromotorController.text = name;
    TextEditingController idVeiculoController = TextEditingController();
    TextEditingController destinoController = TextEditingController();
    TextEditingController dataController = TextEditingController();
    dataController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    TextEditingController posicaoController = TextEditingController();

    if (model != null) {
      labelTitle = "Editando Registro de controle de kilometragem";
      kmInicialController.text = model.kmInicial;
      idPromotorController.text = model.idPromotor;
      idVeiculoController.text = model.idVeiculo;
      destinoController.text = model.destino;
      dataController.text = model.data;
      posicaoController.text = model.posicao;
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  KmInputFormatter(),
                ],
                controller: kmInicialController,
                decoration: const InputDecoration(label: Text("Km Inicial:")),
              ),
              TextFormField(
                controller: idPromotorController,
                decoration:
                    const InputDecoration(label: Text("Promotor de vendas")),
              ),
              ValueListenableBuilder<List<Veiculo>>(
                valueListenable: listVeiculos,
                builder: (context, veiculos, _) {
                  if (veiculos.isEmpty) {
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
                          value: idVeiculoController.text.isEmpty
                              ? null
                              : idVeiculoController.text,
                          hint: const Text('Selecione o Veículo'),
                          isExpanded: true,
                          underline: const SizedBox(),
                          // Remove a linha padrão
                          items: veiculos.map((Veiculo veiculo) {
                            return DropdownMenuItem<String>(
                              value: veiculo.idVeiculo,
                              child: Text(
                                  '${veiculo.modelo} Placa: ${veiculo.placa}'),
                            );
                          }).toList(),
                          onChanged: (String? novoValor) {
                            idVeiculoController.text = novoValor ?? '';
                            selected.value = novoValor ?? '';
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              TextFormField(
                controller: destinoController,
                decoration: const InputDecoration(label: Text("Destino")),
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
              ValueListenableBuilder(
                valueListenable: posicaoAtual,
                builder: (context, value, ___) {
                  if (value != null) {
                    posicaoController.text =
                        "latitude:${value.latitude} longitude: ${value.longitude}";
                  }
                  return TextFormField(
                    controller: posicaoController,
                    decoration: InputDecoration(
                        label: Text(
                            value != null ? "Posicao gps" : "Carregando..")),
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
                      KmControle newKmControle = KmControle(
                        idKmControle: Uuid().v1(),
                        kmInicial: kmInicialController.text,
                        idPromotor: uid,
                        idVeiculo: idVeiculoController.text,
                        destino: destinoController.text,
                        data: dataController.text,
                        posicao: posicaoController.text,
                      );
                      if (model != null) {
                        newKmControle.idKmControle = model.idKmControle;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      db
                          .collection('usuario/$uid/kmControle')
                          .doc(newKmControle.idKmControle)
                          .set(newKmControle.toMap())
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
    setState(() {
      isLoading = false;
    });
  }

  refresh() async {
    List<KmControle> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection('usuario/$uid/kmControle').get();

    for (var doc in snapshot.docs) {
      temp.add(KmControle.fromMap(doc.data()));
    }
    setState(() {
      listKmControle = temp;
      isLoading = false;
    });
  }

  void getLocalidade() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Serviço de localizaçao desativado');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissao de localizaçao negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permissao de localizaçao negada permanentemente');
    }

    Position position = await Geolocator.getCurrentPosition();
    posicaoAtual.value = position;
  }

  buscaVeiculo() async {
    List<Veiculo> veiculos = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection('usuario/$uid/veiculo').get();

    for (var doc in snapshot.docs) {
      veiculos.add(Veiculo.fromMap(doc.data()));
    }
    listVeiculos.value = veiculos;
  }

  remove(KmControle kmControleM) {
    db
        .collection('usuario/$uid/kmControle')
        .doc(kmControleM.idKmControle)
        .delete();
    refresh();
  }
}
