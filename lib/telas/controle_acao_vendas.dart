import '../telas/registra_acao_vendas.dart';
import 'package:flutter/material.dart';

class ControleAcaoVendas extends StatelessWidget {
  const ControleAcaoVendas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Controle de Veiculos'),),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  Text('Data:', style: TextStyle(fontSize: 16.0)),
                  Text('Revenda:', style: TextStyle(fontSize: 16.0)),
                  
                ],
              ), 
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
              
                children: [
                  
                  Text( "Nome Gerente:", style: TextStyle(fontSize: 16.0),),
                  Text("Telefone Gerente:", style: TextStyle(fontSize: 16.0),),
                  Icon(Icons.remove_red_eye, color: Colors.black),
                    Icon(Icons.edit, color: Colors.black),
                    Icon(Icons.delete, color: Colors.black),
 ],
              )




),
              
            )
                    
                    ],
              
  
      ),
      floatingActionButton: 
          FloatingActionButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistraAcaoVendas(),),);
            },
          child: Icon(Icons.add),
          
          ),
              );
      
}
}