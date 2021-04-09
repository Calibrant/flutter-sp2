import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sp2/const.dart';
import 'package:flutter_app_sp2/component/padding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'chat/screens/welcome_screen.dart';
import 'component/drawer.dart';
import 'component/elevated_button.dart';
import 'googlemap_screen.dart';
import 'provider_page2.dart';

class ProviderPage extends StatefulWidget {
  ProviderPage({Key key}) : super(key: key);
  static const String id = 'provider_page';

  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  String companyName, companyService, companyDesc, position;
  Location location = Location();
  Geoflutterfire geo;
  //Map<String, double> userLocation;

///////////////////////////////

  getCompanyName(name) {
    this.companyName = name;
  }

  getCompanyServices(service) {
    this.companyService = service;
  }

  getCompanyDesc(desc) {
    this.companyDesc = desc;
  }

/////////////////////////////////////
  createData() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(COLLECTION).doc(companyName);

    var pos = await location.getLocation();
    GeoPoint point = GeoPoint(pos.latitude, pos.longitude);
   //  GeoFirePoint geoFirePoint = geo.point(latitude: pos.latitude, longitude: pos.longitude);
    Map<String, dynamic> companies = {
      COMPANY_NAME: companyName,
      COMPANY_SERVICE: companyService,
      COMPANY_DESC: companyDesc,
      POSITION: point,
    };

    documentReference
        .set(companies)
        .whenComplete(() => print('$companyName created'));
  }

  readData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(COLLECTION).doc(companyName);
    documentReference.get().then((value) {
      print(value.data()[COMPANY_NAME]);
      print(value.data()[COMPANY_SERVICE]);
      print(value.data()[COMPANY_DESC]);
      print(value.data()[POSITION]);
    });
  }

  updateData() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(COLLECTION).doc(companyName);
        var pos = await location.getLocation();
    // GeoFirePoint geoFirePoint = geo.point(latitude: pos.latitude, longitude: pos.longitude);

    GeoPoint point = GeoPoint(pos.latitude, pos.longitude);

    Map<String, dynamic> companies = {
      COMPANY_NAME: companyName,
      COMPANY_SERVICE: companyService,
      COMPANY_DESC: companyDesc,
      POSITION: point,
    };
    documentReference
        .update(companies)
        .whenComplete(() => print('$companyName updated'));
  }

  deleteData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(COLLECTION).doc(companyName);

    documentReference
        .delete()
        .whenComplete(() => print('$companyName deleted'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(child: Text(COLLECTION)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PaddingWidget(
              label: 'Company',
              onChanged: (String nameCompany) {
                getCompanyName(nameCompany);
              },
            ),
            PaddingWidget(
              label: 'Services',
              onChanged: (String service) {
                getCompanyServices(service);
              },
            ),
            PaddingWidget(
              label: 'Description',
              onChanged: (String desc) {
                getCompanyDesc(desc);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButtonWidget(
                  label: 'Create',
                  onPressed: () {
                    createData();
                    _goToProviderPage2();
                  },
                ),
                ElevatedButtonWidget(
                  label: 'Read',
                  onPressed: () {
                    readData();
                    _goToProviderPage2();
                  },
                ),
                ElevatedButtonWidget(
                  label: 'Update',
                  onPressed: () {
                    updateData();
                    _goToProviderPage2();
                  },
                ),
                ElevatedButtonWidget(
                  label: 'Delete',
                  onPressed: () {
                    deleteData();
                    _goToProviderPage2();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: MainMenuBar(),
    );
  }

 Future<void> _goToProviderPage2() async{
    Navigator.pushNamed(context, ProviderPageDetails.id);
  }
}
