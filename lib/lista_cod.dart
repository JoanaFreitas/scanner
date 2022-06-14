

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:scanner/ad_helper.dart';
import 'package:scanner/db_helper.dart';
import 'package:scanner/item_qrcode.dart';
import 'package:url_launcher/url_launcher_string.dart';


class ListCod extends StatefulWidget {
  const ListCod({Key? key}) : super(key: key);

  @override
  State<ListCod> createState() => _ListCodState();
}

class _ListCodState extends State<ListCod> {


  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final _db = ScannerHelper();
  List<ItemQRcode> _qrCodes = [];
  bool _isLoading = true;
  bool _expanded = false;

  _exibirTelaCadastro({ItemQRcode? itemQRcode}) {
  
    _tituloController.text = itemQRcode!.title;
    _descricaoController.text = itemQRcode.description;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Atualizar QRcode'),
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
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    _atualizarQRcode(itemQRcodeSelecionado: itemQRcode);
                    Navigator.pop(context);
                  },
                  child: const Text('Atualizar')),
            ],
          );
        });
  }

  _atualizarQRcode({ItemQRcode? itemQRcodeSelecionado}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    itemQRcodeSelecionado!.title = titulo;
    itemQRcodeSelecionado.description = descricao;

     await _db.atualizarQRcode(itemQRcodeSelecionado);
   

    _tituloController.clear();
    _descricaoController.clear();

    _recuperarQRcode();
  }

  _recuperarQRcode() async {
   
    List qrcodeRecuperado = await _db.recuperarQRcode();
    List<ItemQRcode> listaTemporaria = [];
    for (var item in qrcodeRecuperado) {
      ItemQRcode itemQRcode = ItemQRcode.fromMap(item);
      listaTemporaria.add(itemQRcode);
    }
    setState(() {
      _qrCodes = listaTemporaria;
      _isLoading = false;
    });
    listaTemporaria = [];
  }

  _formatarData(String data) {
    var formatador = DateFormat('d/MM/y');
    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _removerQRcode(int id) async {
    await _db.removerQRcode(id);
    _recuperarQRcode();
  }

    //sobre o banner ads======================================
 late BannerAd _ad;
  bool isLoaded=false;
  
  @override
 void initState(){
super.initState();
_recuperarQRcode();
_ad= BannerAd(
  adUnitId: AdHelper.bannerAdUnitId, 
  request: const AdRequest(),
  size: AdSize.banner, 
  listener: BannerAdListener(
    onAdLoaded: (_){
      setState(() {
        isLoaded=true;
              });
    },
    onAdFailedToLoad: (_,error){
    }
  ), 
  );
  _ad.load();
  }

  @override
void dispose(){
  _ad.dispose();
  super.dispose();
}
  Widget checkForAd(){
if(isLoaded==true){
  return Container(
    child: AdWidget(ad: _ad),
    width: _ad.size.width.toDouble(),
    height: _ad.size.height.toDouble(),
    alignment: Alignment.center,
  );
}else{
  return const SizedBox(height: 50);
}
  }
  //========================================================


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus QRcodes'),
      ),
      body: _isLoading
          ?const Center(child: CircularProgressIndicator())
          : _qrCodes.isEmpty
              ? const Center(child: Text('Sua lista está vazia',
             style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              ))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: _qrCodes.length,
                          itemBuilder: (context, index) {
                            final qrcode = _qrCodes[index];

                            textFormat() {
                              String textInit = qrcode.description;
                              if (textInit.length < 30) {
                                textInit =
                                    textInit + '                              ';
                                return textInit;
                              } else {
                                return textInit;
                              }
                            }

                            abrirUrl() {
                              if (qrcode.description.contains('http')) {
                                launchUrlString(qrcode.description);
                              } else {
                                return;
                              }
                            }

                            onLongPress() {
                              setState(() {
                                _expanded = !_expanded;
                              });
                            }

                            return Dismissible(
                              key: ValueKey(qrcode.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.only(top: 8, right: 8),
                                color: Theme.of(context).errorColor,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.tealAccent,
                                ),
                                alignment: Alignment.topRight,
                              ),
                              confirmDismiss: (_) {
                                return
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                              title: Text(
                                                  'Excluir ${qrcode.title}.'),
                                              content: const Text(
                                                  'Tem certeza que deseja excluir?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(ctx)
                                                            .pop(false),
                                                    child: const Text('Não')),
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(ctx)
                                                            .pop(true),
                                                    child: const Text('Sim')),
                                              ],
                                            )).then(( value) {
                                  if (value ?? false) {
                                    _removerQRcode(qrcode.id!);
                                  }
                                });
                              },
                              child: Card(
                                margin: const EdgeInsets.all(5.0),
                                child: ListTile(
                               
                                  title: Text(qrcode.title),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: abrirUrl,
                                        onLongPress: onLongPress,
                                        child: Text(
                                            !_expanded
                                                ? textFormat()
                                                    .toString()
                                                    .substring(0, 30)
                                                : qrcode.description,
                                            style: qrcode.description
                                                    .contains('http')
                                                ? const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline)
                                                : const TextStyle()),
                                      ),
                                      Text(_formatarData(qrcode.date)),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _exibirTelaCadastro(
                                              itemQRcode: qrcode);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              right: 0), 
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.tealAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    checkForAd()
                  ],
                ),
       );
  }
}
