import '../../model/modelo_km_controle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ControleKm extends StatefulWidget {
  const ControleKm({super.key});

  @override
  State<ControleKm> createState() => _ControleKmState();
}

class _ControleKmState extends State<ControleKm> {
  List<KmControle> listKmControle =[];
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
        title: const Text('Controle kilometragem'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
           // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistroKM(),),);
        showFormModal();
          },
          child: const Icon(Icons.add),
),

        body: (listKmControle.isEmpty) 
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
                  children: List.generate(listKmControle.length, 
                    (index){
                     KmControle kmControleM = listKmControle[index];
                      return 
                        Card(
                        child: Dismissible(
                          key: ValueKey<KmControle>(kmControleM),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 8.0),
                            color: Colors.red,
                          child: const Icon(Icons.delete),
                          ),
                          onDismissed: (diretion){
                            remove(kmControleM);
                          },
                          child: ListTile(
                            onTap: (){
                              //print("Click");
                            },
                            onLongPress: (){
                                showFormModal(model: kmControleM);
                          
                              //print("CLick e segurou");
                            },
                          title:Row(
                            children: [
                              const Text("Registro Kilometragem :",style: TextStyle(fontSize: 24.0)),
                              Text( kmControleM.idKmControle , style: const TextStyle(fontSize: 24.0) ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                            children: [
                            Text( kmControleM.idKmControle , style: const TextStyle(fontSize: 16.0),),
                            Text( kmControleM.data, style: const TextStyle(fontSize: 16.0),),
                            Text( kmControleM.destino  , style: const TextStyle(fontSize: 16.0),),
                            
                          
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
  showFormModal({KmControle? model}){
    
    // Labels à serem mostradas no Modal
    String labelTitle = "Registrar KM";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";
    
    // Controlador do campo que receberá o nome do Campo
    TextEditingController kmInicialController = TextEditingController();
    TextEditingController idPromotorController = TextEditingController();
    TextEditingController idVeiculoCOntroller = TextEditingController();
    TextEditingController destinoController = TextEditingController();
    TextEditingController dataController = TextEditingController();
    TextEditingController posicaoController = TextEditingController();
    


   if(model !=null){
      labelTitle = "Editando Registro de controle de kilometragem";
      kmInicialController.text = model.kmInicial;
      idPromotorController.text = model.idPromotor;
      idVeiculoCOntroller.text = model.idVeiculo;
      destinoController.text = model.destino;
      dataController.text = model.data;
      posicaoController.text = model.posicao;

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
                controller: kmInicialController,
                decoration:
                    const InputDecoration(label: Text("Km Inicial:")),
              ),
              TextFormField(
                controller: idPromotorController,
                decoration:
                    const InputDecoration(label: Text("Promotor de vendas")),
              ),TextFormField(
                controller: idVeiculoCOntroller,
                decoration:
                    const InputDecoration(label: Text("Veiculo")),
              ),TextFormField(
                controller: destinoController,
                decoration:
                    const InputDecoration(label: Text("Destino")),
              ),
              TextFormField(
                controller: dataController,
                decoration:
                    const InputDecoration(label: Text("Data")),
              ),
              TextFormField(
                controller: posicaoController,
                decoration:
                    const InputDecoration(label: Text("Posição Gps")),
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
                      
                    KmControle newKmControle = KmControle(idKmControle: Uuid().v1(), 
                    kmInicial: kmInicialController.text, 
                    idPromotor: idPromotorController.text, 
                    idVeiculo: idVeiculoCOntroller.text, 
                    destino: destinoController.text, 
                    data: dataController.text, 
                    posicao: posicaoController.text,
                    );
                          if(model != null){
                                newKmControle.idKmControle = model.idKmControle;
                          }
                         db.collection('kmControle').doc(newKmControle.idKmControle).set(newKmControle.toMap());
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
      List<KmControle> temp = [];

      QuerySnapshot<Map<String, dynamic>> snapshot =
       await db.collection("kmControle").get();

       for (var doc in snapshot.docs) {
          temp.add(KmControle.fromMap(doc.data()));

       }
    setState(() {
      listKmControle = temp;
    });
}
  void remove(KmControle KmControleM) {
    db.collection("kmControle").doc(KmControleM.idKmControle).delete();
    refresh();
  }
}


