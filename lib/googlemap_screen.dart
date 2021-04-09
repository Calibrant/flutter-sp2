import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sp2/chat/screens/welcome_screen.dart';
import 'package:flutter_app_sp2/const.dart';
import 'package:flutter_app_sp2/provider_page2.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'component/drawer.dart';
import 'data_controller.dart';
import 'provider_page.dart';
import 'streambuilder_test.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

class GoogleMapPage extends StatefulWidget {
  static const String id = 'google_map';

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // TextEditingController _latitudeController, _longitudeController;
  final _firestore = FirebaseFirestore.instance;
  Geoflutterfire geo;
  Stream<List<DocumentSnapshot>> stream;
  final radius = BehaviorSubject<double>.seeded(1.0);
  QuerySnapshot snapshotData;
  final TextEditingController searchController = TextEditingController();
  LocationData _currentPosition;
  Location location = Location();
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);
  LatLng _center = LatLng(41.312710528718796, 69.27733964256669);

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    /* location.onLocationChanged.listen((l) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
        ),
      );
    }); */
  }

  //////////////////////////

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition.latitude, _currentPosition.longitude);
      });
    });
  }

  ///

  initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    double distanceInKm = await Geolocator.distanceBetween(
            _currentPosition.latitude,
            _currentPosition.longitude,
            // 41.312710, 69.277339,
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
    getLoc();
   // getMarkerData();
    // foundMarkers();
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

  foundMarkers() {
    Random rand = Random();
    if (snapshotData.docs.isNotEmpty) {
      for (int i = 0; i < snapshotData.docs.length; ++i) {
        var randMarker2 =
            snapshotData.docs[rand.nextInt(snapshotData.docs.length)];
        initMarker(randMarker2.data(), randMarker2.id);
      }
    }
  }

  @override
 Widget build(BuildContext context) {
    LocationData _currentPosition;
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
          Navigator.pushNamed(context, ProviderDetailsPage.id);
        },
        child: Icon(Icons.send),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 280,
                  height: 40,
                  child: TextField(
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.white),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search Markers',
                      hintStyle: TextStyle(color: Colors.black26),
                    ),
                    // controller: ,
                  ),
                ),
                GetBuilder<DataController>(
                    init: DataController(),
                    builder: (val) {
                      return IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            val.queryData(searchController.text).then((value) {
                              snapshotData = value;
                              setState(() {
                                foundMarkers();
                              });
                            });
                          });
                    })
              ],
            ),
            Center(
              child: Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: mediaQuery.size.width - 30,
                  height: mediaQuery.size.height * (1 / 1.410),
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
