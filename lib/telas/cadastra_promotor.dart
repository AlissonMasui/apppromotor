import '../telas/login.dart';
import 'package:flutter/material.dart';

class CadastraPromotor extends StatelessWidget {
  const CadastraPromotor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(title: Text('CadastraPromotor'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
               style: TextStyle(
                fontSize: 24.0,
                ),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
             style: TextStyle(
              fontSize: 24.0,
                   
              ),
              ),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Data de Nacimento',
              ),
             style: TextStyle(
              fontSize: 24.0,
                   
              ),
              ),
              const TextField(
              decoration: InputDecoration(
                labelText: 'CNH',
              ),
             style: TextStyle(
              fontSize: 24.0,
                   
              ),
              ),
              const TextField(
              decoration: InputDecoration(
                labelText: 'Rg',
              ),
             style: TextStyle(
              fontSize: 24.0,
                   
              ),
              ),
              const TextField(
              decoration: InputDecoration(
                labelText: 'CPF',
              ),
             style: TextStyle(
              fontSize: 24.0,
                   
              ),
              ),
              const TextField(
              decoration: InputDecoration(
                labelText: 'Telefone',
              ),
             style: TextStyle(
              fontSize: 24.0,
                   
              ),
              ),
              const TextField(
              decoration: InputDecoration(
                labelText: 'Endereço',
              ),
             style: TextStyle(
              fontSize: 24.0,
                   
              ),
              ),
              const TextField(
              decoration: InputDecoration(
                labelText: 'E-mail',
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
                  child: const Text('Cadastrar'),
                  onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login(),),);
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