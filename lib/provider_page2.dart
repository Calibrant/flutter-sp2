import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'const.dart';

class ProviderDetailsPage extends StatelessWidget {
  const ProviderDetailsPage({Key key}) : super(key: key);
static const String id = 'provider_page2';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(TITLE_APPBAR_PROVIDER_PAGE),
      ),
      body: Service(),
    );
  }
}

class Service extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(COLLECTION)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                return Container(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        for (var i = 0; i < listDoc.length; i++)
                          Text(
                            documentSnapshot[listDoc[i]],
                            textAlign: kTextAlign,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: listDoc[i] == COMPANY_NAME
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        
                        Text(
                          documentSnapshot[POSITION].toString(),
                          textAlign: kTextAlign,
                          style: kTextTextStyleFontSize,
                        ),
                        Divider(color: Colors.black),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
