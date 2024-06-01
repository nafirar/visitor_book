import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visitor_world/daftar_tamu.dart';
import 'package:visitor_world/model/user_model.dart';

class AddPengunjung extends StatefulWidget {
  const AddPengunjung({Key? key}) : super(key: key);

  @override
  State<AddPengunjung> createState() => _AddPengunjungState();
}

class _AddPengunjungState extends State<AddPengunjung> {
  final controllerNama = TextEditingController();
  final controllerDivisi = TextEditingController();
  final controllerGolongan = TextEditingController();
  final controllerJabatan = TextEditingController();
  final controllerNip = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tamu'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerNama,
            decoration:
                InputDecoration(hintText: 'Nama', border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 21,
          ),
          TextField(
            controller: controllerDivisi,
            decoration: InputDecoration(
                hintText: 'Divisi', border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 21,
          ),
          TextField(
            controller: controllerGolongan,
            decoration: InputDecoration(
                hintText: 'Golongan', border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 21,
          ),
          TextField(
            controller: controllerJabatan,
            decoration: InputDecoration(
                hintText: 'Jabatan', border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 21,
          ),
          TextField(
            controller: controllerNip,
            decoration:
                InputDecoration(hintText: 'NIP', border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton
              (
              onPressed: _isLoading ? null : () async {
                final user = UserModel(
                  nama: controllerNama.text,
                  divisi: controllerDivisi.text,
                  golongan: controllerGolongan.text,
                  jabatan: controllerJabatan.text,
                  url: '',
                  nip: controllerNip.text,
                );

                setState(() {
                  _isLoading = true; // Set loading state to true
                });

                try {
                  await createUser(user);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data tersimpan')),
                  );
                  // Navigate to another page after successful save
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DaftarTamu()),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                } finally {
                  setState(() {
                    _isLoading = false; // Set loading state back to false
                  });
                }
              },
              child: _isLoading
                  ? CircularProgressIndicator() // Show CircularProgressIndicator when loading
                  : Text('Simpan'),
            ),
          )
        ],
      ),
    );
  }

  Future createUser(UserModel user) async {
    //reference docoment
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id  = docUser.id;
    final json = user.toJson();

    //create document and write data to firebase
    await docUser.set(json);
  }
}
