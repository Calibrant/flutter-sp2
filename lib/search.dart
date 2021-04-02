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
        child: Icon(Icons.clear),
        onPressed: () {
          setState(() {
            isExcecutee = false;
          });
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
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
              })
        ],
        title: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search Services',
            hintStyle: TextStyle(color: Colors.white),
          ),
          controller: searchController,
        ),
        backgroundColor: Colors.black,
      ),
      body: isExcecutee
          ? searchData()
          : Container(
              child: Center(
                child: Text(
                  'Search any services',
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
            ),
    );
  }
}
