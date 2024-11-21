import '../../model/modelo_km_controle.dart';
import '../../model/modelo_revenda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ControleRevenda extends StatefulWidget {
  const ControleRevenda({super.key});

  @override
  State<ControleRevenda> createState() => _ControleRevendaState();
}

class _ControleRevendaState extends State<ControleRevenda> {
  List<Revenda> listRevenda =[];
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
          onPressed: (){
           // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistroKM(),),);
        showFormModal();
          },
          child: const Icon(Icons.add),
),

        body: (listRevenda.isEmpty) 
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
                  children: List.generate(listRevenda.length, 
                    (index){
                     Revenda revendaControleM = listRevenda[index];
                      return 
                        Card(
                        child: Dismissible(
                          key: ValueKey<Revenda>(revendaControleM),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 8.0),
                            color: Colors.red,
                          child: const Icon(Icons.delete),
                          ),
                          onDismissed: (diretion){
                            remove(revendaControleM);
                          },
                          child: ListTile(
                            onTap: (){
                              //print("Click");
                            },
                            onLongPress: (){
                                showFormModal(model: revendaControleM);
                          
                              //print("CLick e segurou");
                            },
                          title:Row(
                            children: [
                              const Text("Revenda :",style: TextStyle(fontSize: 24.0)),
                              Text( revendaControleM.nome , style: const TextStyle(fontSize: 24.0) ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                            children: [
                            Text( revendaControleM.nomeDonoGerente, style: const TextStyle(fontSize: 16.0),),
                            Text( revendaControleM.foneDonoGerente  , style: const TextStyle(fontSize: 16.0),),
                            
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
  showFormModal({Revenda? model}){
    
    // Labels à serem mostradas no Modal
    String labelTitle = "Registrar Revenda";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";
    
    // Controlador do campo que receberá o nome do Campo
    TextEditingController nomeController = TextEditingController();
    TextEditingController cnpjController = TextEditingController();
    TextEditingController nomeDonoGerenteController = TextEditingController();
    TextEditingController foneDonoGerenteController = TextEditingController();
    TextEditingController dataNacimentoDonoController = TextEditingController();
    TextEditingController nomeCompradorController = TextEditingController();
    TextEditingController foneCompradorController = TextEditingController();
    TextEditingController dataNacimentoCompradorController = TextEditingController();

   if(model !=null){
      labelTitle = "Editando Registro de Revenda";
      nomeController.text = model.nome;
      cnpjController.text = model.cnpj;
      nomeDonoGerenteController.text = model.nomeDonoGerente;
      foneDonoGerenteController.text = model.foneDonoGerente;
      nomeCompradorController.text = model.nomeDonoGerente;
      dataNacimentoDonoController.text = model.dataNacimentoDono;
      foneCompradorController.text = model.foneComprador;
      dataNacimentoCompradorController.text = model.dataNacimentoComprador;
      
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
                controller: nomeController,
                decoration:
                    const InputDecoration(label: Text("Nome da Revenda:")),
              ),
              TextFormField(
                controller: cnpjController,
                decoration:
                    const InputDecoration(label: Text("CNPJ")),
              ),TextFormField(
                controller: nomeDonoGerenteController,
                decoration:
                    const InputDecoration(label: Text("Nome Dono/Gerente:")),
              ),TextFormField(
                controller: foneDonoGerenteController,
                decoration:
                    const InputDecoration(label: Text("Fone dono/Gerente")),
              ),
              TextFormField(
                controller: dataNacimentoDonoController,
                decoration:
                    const InputDecoration(label: Text("Data nacimento Dono/Gerente:")),
              ),
              TextFormField(
                controller: nomeCompradorController,
                decoration:
                    const InputDecoration(label: Text("Nome Comprador")),
              ),
              TextFormField(
                controller: foneCompradorController,
                decoration:
                    const InputDecoration(label: Text("Fone Comprador:")),
              ),
              TextFormField(
                controller: dataNacimentoCompradorController,
                decoration:
                    const InputDecoration(label: Text("Data nacimento Comprador:")),
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
                      
                    Revenda newRevenda = Revenda(
                      id_revenda: Uuid().v1(),
                       cnpj: cnpjController.text,
                       nome: nomeController.text,
                         nomeDonoGerente: nomeDonoGerenteController.text,
                          foneDonoGerente: foneDonoGerenteController.text,
                           dataNacimentoDono: dataNacimentoDonoController.text,
                            nomeComprador: nomeCompradorController.text,
                             foneComprador: foneCompradorController.text,
                              dataNacimentoComprador: dataNacimentoCompradorController.text,
                              );
                          if(model != null){
                                newRevenda.id_revenda = model.id_revenda;
                          }

                          db.collection('revenda').doc(newRevenda.id_revenda).set(newRevenda.toMap());
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
      List<Revenda> temp = [];

      QuerySnapshot<Map<String, dynamic>> snapshot =
       await db.collection("revenda").get();

       for (var doc in snapshot.docs) {
          temp.add(Revenda.fromMap(doc.data()));

       }
    setState(() {
      listRevenda = temp;
    });
}

  void remove(Revenda revendaM) {
    db.collection("revenda").doc(revendaM.id_revenda).delete();
    refresh();
  }
}

    
  
