
import 'package:geolocator/geolocator.dart';
import 'package:rider_app/Assitants/request_assitance.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/address.dart';
import 'package:rider_app/config_map.dart';
import 'package:provider/provider.dart';


class AssistantMethods {

  Future<String> searchCordinateAddress(Position position, context) async {

    String placeAddress = "";
    String st1,st2,st3,st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.longitude},-${position.latitude}&key=$mapKey";
    print(url);

    var response = await RequestAssitant.getRequest(url);

    if (response != "failed"){
      placeAddress = response["results"][0]["formatted_address"];

      st1= response["results"][0]["address_components"][3]["long_name"];
      st2= response["results"][0]["address_components"][4]["long_name"];
      st3= response["results"][0]["address_components"][5]["long_name"];
      st4= response["results"][0]["address_components"][6]["long_name"];

      Address userPickUpAddress = new Address();
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.placeFormattedAddress = placeAddress;
      userPickUpAddress.placeName = st1+" "+st2+ " "+st3+ " "+st4;
      print("${userPickUpAddress.placeName}");


      Provider.of<AppData>(context, listen: false).upadatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

}