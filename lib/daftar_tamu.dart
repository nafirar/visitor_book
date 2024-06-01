import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visitor_world/model/user_model.dart';

class DaftarTamu extends StatefulWidget {
  const DaftarTamu({Key? key}) : super(key: key);

  @override
  State<DaftarTamu> createState() => _DaftarTamuState();
}

class _DaftarTamuState extends State<DaftarTamu> {

  Stream<List<UserModel>> readUsers() =>
      FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());

  Widget buildUsers(UserModel users) =>
      ListTile(
        // leading: CircleAvatar(
        //   child: Text('${users.golongan!}'),
        // ),
        title: Text('${users.nama!}'),
        subtitle: Text('${users.jabatan!}'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Tamu'),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        '${snapshot.data![index].url}'
                      ),
                    ),
                    title: Text('${snapshot.data![index].nama}'),
                    subtitle: Text('${snapshot.data![index].divisi}'),
                    trailing: Text('Gol : ${snapshot.data![index].golongan}'),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
