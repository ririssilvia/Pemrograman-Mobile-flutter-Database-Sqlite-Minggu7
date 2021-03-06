import 'package:flutter/material.dart';
//letak package folder flutter
import 'package:prakti6/dbhelper.dart';
import 'package:prakti6/entryform.dart';
import 'package:sqflite/sqflite.dart';
//untuk memanggil fungsi yg terdapat di daftar pustaka sqflite
import 'dart:async';
import 'item.dart'; 
//pendukung program asinkron

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Item> itemList;
  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      // ignore: deprecated_member_use
      itemList = List<Item>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Item'),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            // ignore: deprecated_member_use
            child: RaisedButton(
              child: Text("Tambah Item"),
              onPressed: () async {
                var item = await navigateToEntryForm(context, null);
                if (item != null) {
                  //TODO 2 Panggil Fungsi untuk Insert ke DB
                  int result = await dbHelper.insert(item);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<Item> navigateToEntryForm(BuildContext context, Item item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(item);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.ad_units),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Container(
                  child: Text(
                    this.itemList[index].kodeBarang,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
               subtitle: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    this.itemList[index].name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        ),
                  ),
                ),
               Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Rp " + this.itemList[index].price.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15, 
                      ),
                  ),
                ),
              ],
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
              //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
               int result = await dbHelper.delete(this.itemList[index].id);
                  if (result > 0) {
                    updateListView();
                  }
              },
            ),
            onTap: () async {
              var item =
                  await navigateToEntryForm(context, this.itemList[index]);
                //TODO 4 Panggil Fungsi untuk Edit data
                int result = await dbHelper.update(item);
                  if (result > 0) {
                    updateListView();
                  }
            },
          ),
        );
      },
    );
  }

//update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //TODO 1 Select data dari DB
      Future<List<Item>> itemListFuture = dbHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}