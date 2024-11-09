import '../../model/modelo_despesa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ControleDespesas extends StatefulWidget {
  const ControleDespesas({super.key});

  @override
  State<ControleDespesas> createState() => _ControleDespesasState();
}

class _ControleDespesasState extends State<ControleDespesas> {
      List<Despesa> listDespesa = [];
      FirebaseFirestore db = FirebaseFirestore.instance;

   @override
  void initState() {
    refresh();
    super.initState();
    
  }

Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Controle de Despesas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistroDespesas(),),);
        showFormModal();
        },
      child: const Icon(Icons.add),
      
      ),

      body: (listDespesa.isEmpty) 
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
                  children: List.generate(listDespesa.length, 
                    (index){
                     Despesa despesaControleM = listDespesa[index];
                      return 
                        Card(
                        child: Dismissible(
                          key: ValueKey<Despesa>(despesaControleM),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 8.0),
                            color: Colors.red,
                          child: const Icon(Icons.delete),
                          ),
                          onDismissed: (diretion){
                            remove(despesaControleM);
                          },
                          child: ListTile(
                            onTap: (){
                              //print("Click");
                            },
                            onLongPress: (){
                                showFormModal(model: despesaControleM);
                          
                              //print("CLick e segurou");
                            },
                          title:Row(
                            children: [
                              const Text("Registro despesa: :",style: TextStyle(fontSize: 24.0)),
                              Text( despesaControleM.idDespesa , style: const TextStyle(fontSize: 24.0) ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                            children: [
                            
                            Text( despesaControleM.numeroNf, style: const TextStyle(fontSize: 16.0),),
                            Text( despesaControleM.oQue, style: const TextStyle(fontSize: 16.0),),
                            Text( despesaControleM.quando, style: const TextStyle(fontSize: 16.0),),
                            Text( despesaControleM.onde, style: const TextStyle(fontSize: 16.0),),
                            Text( despesaControleM.preco, style: const TextStyle(fontSize: 16.0),),
                            Text( despesaControleM.placa, style: const TextStyle(fontSize: 16.0),),
                            Text( despesaControleM.km, style: const TextStyle(fontSize: 16.0),),
                                                     
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

  
  showFormModal({Despesa? model}) {
    String labelTitle = " Registrar Despesa";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    TextEditingController numroNfController = TextEditingController();
    TextEditingController oQueController = TextEditingController();
    TextEditingController ondeController = TextEditingController();
    TextEditingController quandoController = TextEditingController();
    TextEditingController precoController = TextEditingController();
    TextEditingController kmController = TextEditingController();
    TextEditingController placaController = TextEditingController();
    TextEditingController id_imagemController = TextEditingController();

    if(model !=null){
      labelTitle = "Editando despesa";
      numroNfController.text = model.numeroNf;
      oQueController.text = model.oQue;
      quandoController.text = model.onde;
      precoController.text = model.quando;
      kmController.text = model.preco;
      placaController.text = model.km;
      id_imagemController.text = model.idImagem;
   }
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
                controller: numroNfController,
                decoration:
                    const InputDecoration(label: Text("Numero Nota fiscal:")),
              ),
              TextFormField(
                controller: oQueController,
                decoration:
                    const InputDecoration(label: Text("O que:")),
              ),TextFormField(
                controller: ondeController,
                decoration:
                    const InputDecoration(label: Text("Onde:")),
              ),TextFormField(
                controller: quandoController,
                decoration:
                    const InputDecoration(label: Text("Quando:")),
              ),
              TextFormField(
                controller: precoController,
                decoration:
                    const InputDecoration(label: Text("Preço:")),
              ),
              
              TextFormField(
                controller: kmController,
                decoration:
                    const InputDecoration(label: Text("Km")),
              ),
              TextFormField(
                controller: placaController,
                decoration:
                    const InputDecoration(label: Text("Placa")),
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
                     Despesa newNfcontrole = Despesa(
                      idDespesa: Uuid().v1(),
                      numeroNf: numroNfController.text,
                       oQue: oQueController.text,
                        onde: ondeController.text, 
                        quando: quandoController.text, 
                        preco: precoController.text, 
                        km: kmController.text, 
                        placa: placaController.text, 
                        idImagem: id_imagemController.text
                        );
                          
                          if(model != null){
                                newNfcontrole.idDespesa = model.idDespesa;
                          }

                          db.collection('despesa').doc(newNfcontrole.idDespesa).set(newNfcontrole.toMap());
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
   refresh() async{
      List<Despesa> temp = [];

      QuerySnapshot<Map<String, dynamic>> snapshot = 
      await db.collection("despesa").get();

      for (var doc in snapshot.docs){
        temp.add(Despesa.fromMap(doc.data()));
      }
 setState(() {
      listDespesa = temp;
    });

  }
  
  remove(Despesa despesaM){
    db.collection("despesa").doc(despesaM.idDespesa).delete();
  }
}