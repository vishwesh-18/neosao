import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:latlong2/latlong.dart';
import 'package:neosao/model/StoresModel.dart';

class StoresController extends GetxController {
  RxList<StoresModel> stores = <StoresModel>[].obs;
  Rx<StoresModel?> selectedStore = Rx<StoresModel?>(null);
  RxList<StoresModel> selectedStores = <StoresModel>[].obs;

  final MapController mapController = MapController();
  var zoomLevel = 13.0.obs;
  var center = LatLng(18.5204, 73.8567).obs;
  RxBool isStoresLoading = false.obs;
  String baseUrl = "https://atomicbrain.neosao.online";

  Future<void> getStores() async {
    try {
      isStoresLoading.value = true;
      final response = await http.get(Uri.parse("${baseUrl}//nearest-store"));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        List storesData = responseData['data'];
        stores.value =
            storesData.map((store) => StoresModel.fromJson(store)).toList();
        print("Total store : ${stores.length}");
        for (var i in stores) {
          print(i.storeLocation);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void toggleStoreSelection(StoresModel store) {
    if (selectedStores.contains(store)) {
      selectedStores.remove(store);
    } else {
      selectedStores.add(store);
    }
    update();
  }

  List<Marker> get storeMarkers {
    return selectedStores.map((store) {
      return Marker(
        point: LatLng(
          double.tryParse(store.latitude ?? '0.0') ?? 0.0,
          double.tryParse(store.longitude ?? '0.0') ?? 0.0,
        ),
        width: 40,
        height: 40,
        child: Icon(Icons.location_pin, size: 40, color: Colors.red),
      );
    }).toList();
  }

  void zoomIn() {
    if (zoomLevel.value < 18.0) {
      zoomLevel.value += 1;
      mapController.move(center.value, zoomLevel.value);
    }
  }

  void zoomOut() {
    if (zoomLevel.value > 2.0) {
      zoomLevel.value -= 1;
      mapController.move(center.value, zoomLevel.value);
    }
  }

  void moveToLocation(LatLng newLocation) {
    center.value = newLocation;
    mapController.move(newLocation, zoomLevel.value);
  }

  @override
  void onInit() {
    getStores();

    ever(selectedStore, (store) {
      if (store != null) {
        center.value = LatLng(
          double.tryParse(store.latitude ?? '23.5937') ?? 23.5937,
          double.tryParse(store.longitude ?? '80.9629') ?? 80.9629,
        );
        mapController.move(center.value, zoomLevel.value);

        super.onInit();
      }
    });
  }
}
