import '../../model/Modelo_diario_campo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DiarioCampo extends StatefulWidget {
  const DiarioCampo({super.key});
  @override
  State<DiarioCampo> createState() => _DiarioCampoState();
}

class _DiarioCampoState extends State<DiarioCampo> {
  List<Diario> listDiario =[];
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
        title: const Text('Diario de Campo:'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
           // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistroKM(),),);
        showFormModal();
          },
          child: const Icon(Icons.add),
),

        body: (listDiario.isEmpty) 
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
                  children: List.generate(listDiario.length, 
                    (index){
                     Diario diarioM = listDiario[index];
                      return 
                        Card(
                        child: Dismissible(
                          key: ValueKey<Diario>(diarioM),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 8.0),
                            color: Colors.red,
                          child: const Icon(Icons.delete),
                          ),
                          onDismissed: (diretion){
                            remove(diarioM);
                          },
                          child: ListTile(
                            onTap: (){
                              //print("Click");
                            },
                            onLongPress: (){
                                showFormModal(model: diarioM);
                          
                              //print("CLick e segurou");
                            },
                          title:Row(
                            children: [
                              const Text("Diario:",style: TextStyle(fontSize: 24.0)),
                              Text( diarioM.titulo , style: const TextStyle(fontSize: 24.0) ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                            children: [
                            Text( diarioM.id_revenda , style: const TextStyle(fontSize: 16.0),),
                            Text( diarioM.data   , style: const TextStyle(fontSize: 16.0),),
                            
                          
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
  showFormModal({Diario? model}){
    
    // Labels à serem mostradas no Modal
    String labelTitle = "Adicionar Registro de KM";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";
    
    // Controlador do campo que receberá o nome do Campo
    TextEditingController tituloController = TextEditingController();
    TextEditingController textocontroller = TextEditingController();
    TextEditingController dataController = TextEditingController();
    TextEditingController id_revendaController= TextEditingController();
   if(model !=null){
      labelTitle = "Editando Diario de Campo";
      tituloController.text = model.titulo;
      textocontroller.text = model.texto;
      dataController.text = model.data;
      id_revendaController.text = model.id_revenda;

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
                controller: tituloController,
                decoration:
                    const InputDecoration(label: Text("Titulo:")),
              ),
              TextFormField(
                controller: textocontroller,
                decoration:
                    const InputDecoration(label: Text("Texto")),
              ),TextFormField(
                controller: dataController,
                decoration:
                    const InputDecoration(label: Text("Data")),
              ),TextFormField(
                controller: id_revendaController,
                decoration:
                    const InputDecoration(label: Text("Revenda")),
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
                      
                    Diario newDiario = Diario(
                      id_diario: Uuid().v1(), 
                      titulo: tituloController.text, 
                      texto: textocontroller.text, 
                      data: dataController.text, 
                      id_revenda: id_revendaController.text,
                      );
                          
                          if(model != null){
                                newDiario.id_diario = model.id_diario;
                          }

                          db.collection('diario').doc(newDiario.id_diario).set(newDiario.toMap());
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
      List<Diario> temp = [];

      QuerySnapshot<Map<String, dynamic>> snapshot =
       await db.collection("diario").get();

       for (var doc in snapshot.docs) {
          temp.add(Diario.fromMap(doc.data()));

       }
    setState(() {
      listDiario = temp;
    });
}

  void remove(Diario diarioM) {
    db.collection("diario").doc(diarioM.id_diario).delete();
    refresh();
  }
}

    
  
