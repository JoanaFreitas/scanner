import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanner/app_routes.dart';
import 'package:scanner/db_helper.dart';
import 'package:scanner/item_qrcode.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QRCodePage extends StatefulWidget {
 const QRCodePage({Key? key}) : super(key: key);

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {

 final TextEditingController _tituloController = TextEditingController();
 final TextEditingController _descricaoController = TextEditingController();
 final  _db = ScannerHelper();
   String ticket = '';

  

  _readQRCode() async {
    String qrCodeRes;
    try {
      qrCodeRes = await FlutterBarcodeScanner.scanBarcode(
          '#ffffff', 'Cancelar', false, ScanMode.QR);
      setState(() {
        ticket = qrCodeRes != '-1' ? qrCodeRes : 'Não validado';
        // abrirUrl();
      });
      if (ticket.contains('http')) {
        launchUrlString(ticket);
      } else {
        return;
      }
    } catch (e) {
      qrCodeRes = 'Não foi possivel ler QRcode';
    }
  }


//============================================
  _exibirTelaCadastro() {
    _descricaoController.text = ticket;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Salvar QRcode?'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _tituloController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      hintText: 'Você pode digitar um titulo...',
                    ),
                  ),
                  TextField(
                    // enabled: false,
                    controller: _descricaoController,
                    autofocus: true,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Descricao',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    limpaCampo();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    _salvarQRcode();
                    limpaCampo();
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar')),
            ],
          );
        });
  }


  _salvarQRcode() async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    //salvando
    ItemQRcode itemQRcode = ItemQRcode(
        title: titulo, description: descricao, date: DateTime.now().toString());
   // int resultado = 
    await _db.salvarQRcode(itemQRcode);

    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
      content: Text(' QRcode listado com sucesso!'),
      duration: Duration(seconds: 3),
    ));
  }//==========================
  limpaCampo() {
    setState(() {
      _tituloController.text = '';
      _descricaoController.text = '';
    });
  }
  

  @override
  Widget build(BuildContext context) {// _comparaQRcode();
   
    return Scaffold(
      body:  Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (ticket != '')
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        'Ticket: $ticket',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                        if (ticket != 'Não validado')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: TextButton(
                          onPressed: () async {
                            await _exibirTelaCadastro();
                            setState(() => ticket = '');
                          },
                          child: const Text('Deseja Salvar?')),
                    ),
                  ],
                ),
              ElevatedButton.icon(
                  onPressed: _readQRCode,
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Scanear'))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Padding(
              padding:  EdgeInsets.all(8.0), child: Icon(Icons.list)),
          onPressed: () async {
            await Navigator.of(context).pushNamed(
              AppRoutes.LIST_COD,
            );
            setState(() => ticket = '');
          }),
    );
  }
}
