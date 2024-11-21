import '../../model/modelo_veiculo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ControleVeiculos extends StatefulWidget {
  const ControleVeiculos({super.key});

  @override
  State<ControleVeiculos> createState() => _ControleVeiculosState();
}

class _ControleVeiculosState extends State<ControleVeiculos> {
  List<Veiculo> listVeiculo =[];
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
        title: const Text('Controle Veiculos:'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
           // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistroKM(),),);
        showFormModal();
          },
          child: const Icon(Icons.add),
),

        body: (listVeiculo.isEmpty) 
        ? const Center(
             child: Text(
                "Nenhuma Registro ainda.\nVamos criar o primeiro?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              )
              : RefreshIndicator(
                onRefresh: (){
                  return refresh();

                },
                child:ListView(
                  children: List.generate(listVeiculo.length, 
                    (index){
                     Veiculo veiculoM = listVeiculo[index];
                      return 
                        Card(
                        child: Dismissible(
                          key: ValueKey<Veiculo>(veiculoM),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 8.0),
                            color: Colors.red,
                          child: const Icon(Icons.delete),
                          ),
                          onDismissed: (diretion){
                            remove(veiculoM);
                          },
                          child: ListTile(
                            onTap: (){
                              //print("Click");
                            },
                            onLongPress: (){
                                showFormModal(model: veiculoM);
                          
                              //print("CLick e segurou");
                            },
                          title:Row(
                            children: [
                              const Text("Veiculo :",style: TextStyle(fontSize: 24.0)),
                              Text( veiculoM.modelo , style: const TextStyle(fontSize: 24.0) ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                            children: [
                            Text( veiculoM.placa , style: const TextStyle(fontSize: 16.0),),
                            Text(veiculoM.kmAtual, style: const TextStyle(fontSize: 16.0),)
                          
                                              ],
                                        ),
                                        
                                      ),
                        )
          );
        }

        ),
      
      
      ),
      ),
      );
  }
  showFormModal({Veiculo? model}){
    
    // Labels à serem mostradas no Modal
    String labelTitle = "Adicionar Veiculo:";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";
    
    // Controlador do campo que receberá o nome do Campo
    TextEditingController modeloController = TextEditingController();
    TextEditingController marcaController = TextEditingController();
    TextEditingController placaController = TextEditingController();
    TextEditingController revisaoController = TextEditingController();
    TextEditingController kmAtualController= TextEditingController();
   if(model !=null){
      labelTitle = "Editando Registro de Veiculo";
      modeloController.text = model.modelo;
      marcaController.text = model.marca;
      placaController.text = model.placa;
      revisaoController.text = model.revisao;
      kmAtualController.text = model.kmAtual;

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
                controller: modeloController,
                decoration:
                    const InputDecoration(label: Text("Modelo:")),
              ),
              TextFormField(
                controller: marcaController,
                decoration:
                    const InputDecoration(label: Text("Marca")),
              ),
              TextFormField(
                controller: placaController,
                decoration:
                    const InputDecoration(label: Text("Placa")),
              ),
              TextFormField(
                controller: revisaoController,
                decoration:
                    const InputDecoration(label: Text("Revisão:")),
              ),
              TextFormField(
                controller: kmAtualController,
                decoration:
                    const InputDecoration(label: Text("KmAtual")),
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
                     
                    Veiculo newVeiculo = Veiculo(
                      idVeiculo: const Uuid().v1(), 
                      modelo: modeloController.text, 
                      marca: marcaController.text, 
                      placa: placaController.text, 
                      revisao: revisaoController.text,
                      kmAtual: kmAtualController.text,
                      );
                          
                          if(model != null){
                                newVeiculo.idVeiculo = model.idVeiculo;
                          }

                          db.collection('veiculo').doc(newVeiculo.idVeiculo).set(newVeiculo.toMap());
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
      List<Veiculo> temp = [];

      QuerySnapshot<Map<String, dynamic>> snapshot =
       await db.collection("veiculo").get();

       for (var doc in snapshot.docs) {
          temp.add(Veiculo.fromMap(doc.data()));

       }
    setState(() {
      listVeiculo = temp;
    });
}

  void remove(Veiculo model) {
    db.collection("veiculo").doc(model.idVeiculo).delete();
    refresh();
  }
}

    
  
