import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text("Home",style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: (){
            _scaffoldKey.currentState.openDrawer();
          },
            child: Icon(Icons.menu,color: Colors.black,)),
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green),
                    image: DecorationImage(image: AssetImage("assets/images/avatar.jpg"))
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ////////////
            SizedBox(height: 30,),
            Divider(color: Colors.grey.withOpacity(0.4),),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.history),
                      SizedBox(width: 15,),
                      Text("History",style: TextStyle(
                        fontSize: 13,color: Colors.black
                      ),)
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 15,),
                      Text("Vist Profile",style: TextStyle(
                          fontSize: 13,color: Colors.black
                      ),)
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Icon(Icons.info),
                      SizedBox(width: 15,),
                      Text("About",style: TextStyle(
                          fontSize: 13,color: Colors.black
                      ),)
                    ],
                  ),

                ],
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
            },
          ),
          Positioned(
            left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 320.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.2,
                      offset: Offset(0.7,0.7)
                    )
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                  child: Column(
                    children: [
                      SizedBox(height: 6.0,),
                      Text("Hey There,",style: TextStyle(
                          fontSize: 13.0
                      ),),
                      Text("Where to?",style: TextStyle(
                          fontSize: 20.0
                      ),),
                      SizedBox(height: 20.0,),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 2.0,
                                  spreadRadius: 0.2,
                                  offset: Offset(0.7,0.7)
                              )
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Icon(Icons.search,color: Colors.black,),
                              SizedBox(height: 10.0,),
                              Text("Search Drop off",style: TextStyle(
                                  fontSize: 15.0
                              ),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0,),

                      Row(
                        children: [
                          Icon(Icons.home,color: Colors.grey,),
                          SizedBox(height: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Home",style: TextStyle(
                                  fontSize: 15.0
                              ),),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
