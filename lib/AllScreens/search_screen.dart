import 'package:flutter/material.dart';
import 'package:rider_app/Assitants/request_assitance.dart';
import 'package:rider_app/config_map.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Drop off",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
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
              padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 20),
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
                            onChanged:  (value){
                              findPlace(value);
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
          )
        ],
      ),
    );
  }


  void findPlace(String placeName) async {

    if(placeName.length > 1){

      String autoComplete = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:NG";

      var res = await RequestAssitant.getRequest(autoComplete);

      if (res == "failed"){
        return;
      }

      print(res);

    }
  }
}
