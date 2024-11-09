import 'package:flutter/material.dart';

class RegistraAcaoVendas extends StatelessWidget {
  const RegistraAcaoVendas({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      appBar: AppBar(title: Text('Registro Ação de Vendas'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Revenda',
                ),
               style: TextStyle(
                fontSize: 24.0,
                ),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Promotor',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Data:',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
             const TextField(
              decoration: InputDecoration(
                labelText: 'Proposito',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
             const TextField(
              decoration: InputDecoration(
                labelText: 'Proposito Alcansado',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Imagens',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
             
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: const Text('Registra'),
                  onPressed: (){
                       Navigator.pop(context);

                  },
                  
                ),
              ),
            ),
        
          ],
        ),
      )


    );
  }
}