import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=6f30cb41";

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(

        brightness: Brightness.dark,

        primaryColor: Colors.white,

        hintColor: Colors.amber,

        accentColor: Colors.amber,

      ),
    debugShowCheckedModeBanner: false,
  ));
}


Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();

  double dolar;
  double euro;
  double bitcoin;

  void _realChanged(String text)
  {
    if (text.isEmpty){
      _clearAll();
    }else{
      double real = double.parse(text);
      dolarController.text = (real/dolar).toStringAsFixed(2);
      euroController.text = (real/euro).toStringAsFixed(2);
      bitcoinController.text = (real/bitcoin).toStringAsFixed(2);
    }


  }
  void _dolarChanged(String text)
  {
    if (text.isEmpty){
      _clearAll();
    }else{
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
      bitcoinController.text = (dolar * this.dolar / bitcoin).toStringAsFixed(2);
    }

  }
  void _euroChanged(String text)
  {
    if (text.isEmpty){
      _clearAll();
    }else{
      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
      bitcoinController.text = (euro * this.euro / bitcoin).toStringAsFixed(2);
    }

  }

  void _bitCoinChanged(String text)
  {
    if (text.isEmpty){
      _clearAll();
    }else{
      double bitcoin = double.parse(text);
      realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
      dolarController.text = (bitcoin * this.bitcoin / dolar).toStringAsFixed(2);
      euroController.text = (bitcoin * this.bitcoin / euro).toStringAsFixed(2);
    }

  }


  void _clearAll()
  {
    realController.text = dolarController.text = euroController.text = bitcoinController.text = "";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ BruConvert \$"),
          centerTitle: true,
          backgroundColor: Colors.amber,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (){
                _clearAll();
              },
            )
          ],
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (contex, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text("Carregando Dados",
                          style: TextStyle(color: Colors.amber, fontSize: 25.0),
                          textAlign: TextAlign.center));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Error ao Carregar Dados :(",
                            style:
                                TextStyle(color: Colors.amber, fontSize: 25.0),
                            textAlign: TextAlign.center));
                  } else {
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,size: 150.0,color: Colors.amber),
                          buildTextField("Reais", "R\$", realController, _realChanged),
                          Divider(),
                          buildTextField("Dólares", "US\$", dolarController, _dolarChanged),
                          Divider(),
                            buildTextField("Euros", "€\$", euroController, _euroChanged),
                          Divider(),
                          buildTextField("Bitcoin", "₿\$", bitcoinController, _bitCoinChanged)

                        ],
                      ),
                    );
                  }
              }
              ;
            }));
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f)
{
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.amber,
          fontSize: 25.0,
        ),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
        color: Colors.amber,
        fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}