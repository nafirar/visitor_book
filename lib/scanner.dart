import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:visitor_world/user_model.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {

  Future<UserModel?> readUser(String code) async{
    final docUser = FirebaseFirestore.instance.collection('users').doc(code);
    final snapshot = await docUser.get();
    if(snapshot.exists) {
      return UserModel.fromJson(snapshot.data()!);
    }
  }

  Future scanBarcode() async {
    await FlutterBarcodeScanner.scanBarcode("#009922", "CANCEL", true, ScanMode.QR)
        .then((String code) {
      showDialog(
          context: context,
          builder: (_) => badgesDialog(code));
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SCAN TAMU'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                scanBarcode();
              },
              icon: Icon(
                Icons.people_alt,
                size: 24.0,
              ),
              label: Text('Scan Pengunjung'), // <-- Text
            ),
          ],
        ),
      ),
    );
  }
  Widget badgesDialog(String code) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: FutureBuilder<UserModel?>(
        future: readUser(code),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Text(
                        'DATA PENGUNJUNG',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Image.network(
                          '${snapshot.data?.url}',
                          fit: BoxFit.contain,
                          width: 230,
                          height: 175,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            width: 300,
                            child: Text(
                              'Tempat Kerja : ${snapshot.data?.divisi}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: 300,
                            child: Text(
                              'Nama : ${snapshot.data?.nama}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: 300,
                            child: Text('NIP : ${snapshot.data?.nip}',
                                style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 18,)),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: 300,
                            child: Text('Golongan : ${snapshot.data?.golongan}',
                                style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 18,)),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: 300,
                            child: Text('Jabatan : ${snapshot.data?.jabatan}',
                                style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 18,)),
                          ),
                          SizedBox(height: 8,),

                          Container(
                            width: 300,
                            child: Text('Tanggal Kunjungan : ${DateFormat.yMMMEd().format(DateTime.now())}',
                                style:
                                TextStyle(fontSize: 15)),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style:
                                TextButton.styleFrom(backgroundColor: Colors.deepPurple),
                                onPressed: () async {
                                  final docUser = FirebaseFirestore.instance.collection('visitor').doc(code);
                                  final json = {
                                    'nama' : snapshot.data?.nama,
                                    'divisi' : snapshot.data?.divisi,
                                    'golongan' : snapshot.data?.golongan,
                                    'jabatan' : snapshot.data?.jabatan,
                                    'nip' : snapshot.data?.jabatan,
                                    'date' : DateTime.now(),
                                    'url' : snapshot.data?.url
                                  };
                                  await docUser.set(json).then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data tersimpan')));
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text(
                                  'Simpan data',
                                  style: TextStyle(
                                    color: Colors.white, fontSize: 15
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if(snapshot.connectionState == ConnectionState.done && !snapshot.hasData){
            return  Center(child: Text('DATA TIDAK DITEMUKAN!', style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red
            ),),);
          }
          else return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
