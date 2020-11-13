import 'package:flutter/cupertino.dart';
import 'package:rider_app/Models/address.dart';

class AppData extends ChangeNotifier {

  Address  pickUpLocation , dropOffLocation;

  void upadatePickUpLocationAddress(Address address){
    pickUpLocation = address;
    notifyListeners();
  }


  void updateDropOffLocationAddress(Address dropOfAddress){
    dropOffLocation = dropOfAddress;
    notifyListeners();
  }

}