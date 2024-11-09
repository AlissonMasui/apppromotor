import '../Services/auth_service.dart';
import '../authentication/components/show_senha_confirmacao_dialog.dart';
import '../telas/ControleDespesas.dart';
import '../telas/Controle_veiculos.dart';
import '../telas/controle_KM.dart';
import '../telas/controle_acao_vendas.dart';
import '../telas/controle_diario_campo.dart';
import '../telas/controle_revenda.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Homepage extends StatefulWidget {
  final User user;
  const Homepage({super.key, required this.user});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
   
     @override
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
              ),
              accountName: Text(
                (widget.user.displayName != null)
                    ? widget.user.displayName!
                    : "",
              ),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text("Remover conta"),
              onTap: () {
                showSenhaConfirmacaoDialog(context: context, email: "");
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
              onTap: () {
                AuthService().deslogar();
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(title: Text('App Promotor'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
             Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: 
                  const Text('Controle de KM'),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ControleKm(),),);
                  },
                  
                  
                ),
              ),
            ),
        Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: const Text('Controle Despesas'),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ControleDespesas(),),);
                  },
                  
                  
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: const Text('Diario de campo'),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DiarioCampo(),),);
                  },
                  
                  
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: const Text('Controle de Ações'),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ControleAcaoVendas(),),);
                  },
                  
                  
                ),
              ),
            ),Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: const Text('Controle de revendas'),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ControleRevenda(),),);
                  },
                  
                  
                ),
              ),
            ),Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: const Text('Controle de veiculos'),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ControleVeiculos(),),);
                  },
                  
                  
                ),
              ),
            ),
          ],
        ),
      ),


    );
  }
  
  }

