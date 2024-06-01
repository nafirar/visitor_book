import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visitor_world/addPengunjung.dart';
import 'package:visitor_world/model/user_model.dart';

class Pengunjung extends StatefulWidget {
  const Pengunjung({Key? key}) : super(key: key);

  @override
  State<Pengunjung> createState() => _PengunjungState();
}

class _PengunjungState extends State<Pengunjung> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('KUNJUNGAN'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPengunjung()),
                  );
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data Pengunjung',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Pada ${DateFormat.yMMMEd().format(DateTime.now())}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )
                    ],
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    onPressed: () async {
                      var collection =
                          FirebaseFirestore.instance.collection('visitor');
                      var snapshots = await collection.get();
                      for (var doc in snapshots.docs) {
                        await doc.reference.delete();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data terhapus')));
                    },
                    child: Text(
                      'Hapus data',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<List<UserModel>>(
                stream: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    '${snapshot.data![index].url}')),
                            title: Text('${snapshot.data![index].nama}'),
                            subtitle: Text('${snapshot.data![index].divisi}'),
                            trailing: Text(
                                '${DateFormat.yMMMEd().format(DateTime.now())}'),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Something went wrong! ${snapshot.error}'));
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                },
              ),
            ),
          ],
        ));
  }

  Stream<List<UserModel>> getUser() => FirebaseFirestore.instance
      .collection('visitor')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
}
