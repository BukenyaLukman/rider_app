import 'package:flutter/foundation.dart';
import 'package:rider_app/Models/address.dart';

class AppData extends ChangeNotifier
{
  Address pickupLocation, dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAddress)
  {
    pickupLocation = pickUpAddress;
    notifyListeners();
  }


  void updateDropOffLocationAddress(Address dropOffAddress)
  {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}