import 'package:flutter/material.dart';

class RegistroDiaroDeCampo extends StatelessWidget {
  const RegistroDiaroDeCampo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: Text('Registro de Diario'),),
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
                labelText: 'Titulo',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
         keyboardType: TextInputType.number,
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Texto',
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