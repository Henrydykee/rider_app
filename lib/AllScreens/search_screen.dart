import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Assitants/request_assitance.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/address.dart';
import 'package:rider_app/Models/place_prediction.dart';
import 'package:rider_app/config_map.dart';
import 'package:rider_app/widget/progress_dialog.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<PlacePrediction> placePredictionList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Set Drop off",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 3.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7))
            ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  // Stack(
                  //   children: [
                  //     GestureDetector(
                  //         onTap: () {
                  //           Navigator.of(context).pop();
                  //         }, child: Icon(Icons.arrow_back)),
                  //     Center(
                  //       child: Text(
                  //         "Set Drop Off",
                  //         style: TextStyle(fontSize: 18.0),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/pickicon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(width: 18.0),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "PickUp Location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0)),
                          ),
                        ),
                      ))
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/desticon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(width: 18.0),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                findPlace(value);
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Destination Location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0)),
                          ),
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
          // dispaly predictio
          (placePredictionList.length > 0)
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        return PredictionTile(
                          placePrediction: placePredictionList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: placePredictionList.length),
                )
              : Container()
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoComplete =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:NG";

      var res = await RequestAssitant.getRequest(autoComplete);

      if (res == "failed") {
        return;
      }

      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var placeList = (predictions as List)
            .map((e) => PlacePrediction.fromJson(e))
            .toList();
        setState(() {
          placePredictionList = placeList;
        });
      }
    }
  }
}

 void getPlaceAdressDetails(String PlaceId, context) async {
  
  showDialog(context: context, builder: (BuildContext context) => ProgressDialog(message: "Setting drop off"));
  
  String placeAddressUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$PlaceId&key=$mapKey";

  var res = await RequestAssitant.getRequest(placeAddressUrl);

  Navigator.of(context).pop();
  if(res == "failed"){
    return;
  }

  if (res["status"] == "OK"){
    Address address = Address();
    address.placeName = res["result"]["name"];
    address.placedId = PlaceId;
    address.latitude = res["result"]["geometry"]["location"]["lat"];
    address.longitude = res["result"]["geometry"]["location"]["lng"];
    Provider.of<AppData>(context).updateDropOffLocationAddress(address);
    
    Navigator.pop(context, "obtainDirection");
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePrediction placePrediction;
  PredictionTile({Key key, this.placePrediction, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        getPlaceAdressDetails(placePrediction.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 10.0,
            ),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placePrediction.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        placePrediction.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
