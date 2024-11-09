import 'package:flutter/material.dart';

class RegistroVeiculos extends StatelessWidget {
  const RegistroVeiculos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: Text('Registro de veiculo'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Modelo:',
                ),
               style: TextStyle(
                fontSize: 24.0,
                ),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Marca',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Placa',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
             const TextField(
              decoration: InputDecoration(
                labelText: 'Revisão',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
             const TextField(
              decoration: InputDecoration(
                labelText: 'KmAtual',
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
                  child: const Text('Registro'),
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