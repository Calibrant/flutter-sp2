import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sp2/chat/screens/welcome_screen.dart';
import 'package:flutter_app_sp2/const.dart';
import 'package:flutter_app_sp2/provider_page2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'component/drawer.dart';
import 'provider_page.dart';
import 'streambuilder_test.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';

class GoogleMapPage extends StatefulWidget {
  static const String id = 'google_map';

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  TextEditingController _latitudeController, _longitudeController;
  final _firestore = FirebaseFirestore.instance;
  Geoflutterfire geo;
  Stream<List<DocumentSnapshot>> stream;
  final radius = BehaviorSubject<double>.seeded(1.0);
  // final LatLng _center = const LatLng(41.26465, 69.21627);
  
  
  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    double distanceInKm = await Geolocator.distanceBetween(
            41.312710, //528718796,
            69.277339, //64256669,
            specify[POSITION].latitude,
            specify[POSITION].longitude) /
        1000;
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify[POSITION].latitude, specify[POSITION].longitude),
      infoWindow: InfoWindow(
        title: specify[COMPANY_NAME],
        snippet: distanceInKm.toStringAsFixed(2) + 'km',
      ),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

 

  getMarkerData() {
    FirebaseFirestore.instance.collection(COLLECTION).get().then((pos) {
      if (pos.docs.isNotEmpty) {
        for (int i = 0; i < pos.docs.length; ++i) {
          initMarker(pos.docs[i].data(), pos.docs[i].id);
        }
      }
    });
  }

  @override
  void initState() {
    getMarkerData();
    super.initState();
  
    /*  _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();

    geo = Geoflutterfire();
    GeoFirePoint center =
        geo.point(latitude: 41.312710528718796, longitude: 69.27733964256669);
    stream = radius.switchMap((rad) {
      var collectionReference = _firestore.collection(COLLECTION);
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    }); */
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(child: Text(GOOGLE_MAP_PAGE_APPBAR_TITLE)),
        actions: [
          IconButton(
            onPressed: mapController == null
                ? null
                : () {
                    _showHome();
                  },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, ProviderPageDetails.id);
           /* Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ProviderPage2();
          }));  */
        },
        child: Icon(Icons.navigate_next),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: mediaQuery.size.width - 30,
                  height: mediaQuery.size.height * (1 / 1.325),
                  child: GoogleMap(
                    /////////////////////GOOGLE MAP////////////////////
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: const CameraPosition(
                        target: LatLng(41.312710528718796, 69.27733964256669),
                        zoom: 12.0),
                    markers: Set<Marker>.of(markers.values),
                  ),
                ),
              ),
            ),
          /*   Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Slider(
                min: 1,
                max: 30,
                divisions: 30,
                value: _value,
                label: _label,
                activeColor: Colors.blue,
                inactiveColor: Colors.blue.withOpacity(0.2),
                onChanged: (double value) => changed(value),
              ),
            ), */
            /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 100,
                    child: TextField(
                      controller: _latitudeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: 'lat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  Container(
                    width: 100,
                    child: TextField(
                      controller: _longitudeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'lng',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      final lat = double.parse(_latitudeController.text);
                      final lng = double.parse(_longitudeController.text);
                      _addPoint(lat, lng);
                    },
                    child: const Text(
                      'ADD',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ), 
                MaterialButton(
                color: Colors.amber,
                child: const Text(
                  'Add nested ',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  final lat = double.parse(_latitudeController.text);
                  final lng = double.parse(_longitudeController.text);
                  _addNestedPoint(lat, lng);
                },
              )  */
          ],
        ),
      ),

///////////////////////////////////////////////////////////

      drawer: MainMenuBar(),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      stream.listen((List<DocumentSnapshot> documentList) {
        _updateMarkers(documentList);
      });
    });
  }

  void _showHome() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      const CameraPosition(
        target: LatLng(41.312710528718796, 69.27733964256669),
        zoom: 10.0,
      ),
    ));
  }

  void _addPoint(double lat, double lng) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore
        .collection('locations')
        .add({'name': 'random name', 'position': geoFirePoint.data}).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  //example to add geoFirePoint inside nested object
  void _addNestedPoint(double lat, double lng) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore.collection('nestedLocations').add({
      'name': 'random name',
      'address': {
        'location': {'position': geoFirePoint.data}
      }
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  void _addMarker(specify, specifyId) async {
    var markerVal = specifyId;
    final MarkerId markerId = MarkerId(markerVal);
    double distanceInKm = await Geolocator.distanceBetween(
            41.312710528718796,
            69.27733964256669,
            specify[POSITION].latitude,
            specify[POSITION].longitude) /
        1000;
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify[POSITION].latitude, specify[POSITION].longitude),

      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ////////////INFOWINDOW/////////////

      infoWindow: InfoWindow(
          title: 'latlng', snippet: distanceInKm.toStringAsFixed(2) + 'km'),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) {
      final GeoPoint point = document.data()['position']['geopoint'];
      _addMarker(point.latitude, point.longitude);
    });
  }

  double _value = 1.0;
  String _label = '';

  changed(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
      markers.clear();
    });
    radius.add(value);
  }
}
