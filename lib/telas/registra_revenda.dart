import 'package:flutter/material.dart';

class RegistraRevenda extends StatelessWidget {
  const RegistraRevenda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: Text('Registro de Revendas'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nome da revenda:',
                ),
               style: TextStyle(
                fontSize: 24.0,
                ),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Cnpj',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nome dono/Gerente',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
             const TextField(
              decoration: InputDecoration(
                labelText: 'Telefone dono/Gerente',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
             const TextField(
              decoration: InputDecoration(
                labelText: 'Data nacimento dono/Gerente',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
             const TextField(
              decoration: InputDecoration(
                labelText: 'Nome Comprador',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
             const TextField(
              decoration: InputDecoration(
                labelText: 'Telefone Comprador:',
              ),
             style: TextStyle(
              fontSize: 24.0,
             
        
              ),
            ),
             const TextField(
              decoration: InputDecoration(
                labelText: 'Data nacimento Comprador:',
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