import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sp2/data_controller.dart';
import 'package:get/get.dart';
import 'const.dart';

class Search extends StatefulWidget {
  static const String id = 'search';
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool isExcecutee = false;

  @override
  Widget build(BuildContext context) {
    searchData() {
      return ListView.builder(
          itemCount: snapshotData.docs.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {},
              child: ListTile(
                title: Text(
                  snapshotData.docs[index].data()[COMPANY_NAME],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
                subtitle: Text(
                  snapshotData.docs[index].data()[COMPANY_SERVICE],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            );
          });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.clear),
        onPressed: () {
          setState(() {
            isExcecutee = false;
          });
        },
      ),
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          GetBuilder<DataController>(
              init: DataController(),
              builder: (val) {
                return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      val.queryData(searchController.text).then((value) {
                        snapshotData = value;
                        setState(() {
                          isExcecutee = true;
                        });
                      });
                    });
              }),
        ],
        title: Container(
          width: 280,
          height: 40,
          child: TextField(
            style: TextStyle(color: Colors.black, fontSize: 20.0),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),
                borderRadius: new BorderRadius.circular(10.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              hintText: 'Search Services',
              hintStyle: TextStyle(color: Colors.black26),
            ),
            controller: searchController,
          ),
        ),
      ),
      body: isExcecutee
          ? searchData()
          : Container(
              child: Center(
                child: Text(
                  'Search any services',
                  style: TextStyle(color: Colors.black38, fontSize: 30.0),
                ),
              ),
            ),
    );
  }
}
