import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';
import 'package:neosao/controllers/stores_controller.dart';
import 'package:neosao/model/StoresModel.dart';

import '../Widget/app_widgets.dart';

class StoresScreen extends StatelessWidget {
  StoresScreen({super.key});
  final StoresController storesController = Get.put(StoresController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Stores",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Obx(
                () => Stack(
                  children: [
                    FlutterMap(
                        mapController: storesController.mapController,
                        options: MapOptions(
                          initialCenter: LatLng(
                            double.tryParse(storesController
                                        .selectedStore.value?.latitude ??
                                    '23.5937') ??
                                23.5937,
                            double.tryParse(storesController
                                        .selectedStore.value?.longitude ??
                                    '80.9629') ??
                                80.9629,
                          ),
                          initialZoom: 7.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          Obx(() => MarkerLayer(
                              markers: storesController.storeMarkers)),
                        ]),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            width: 40.w,
                            height: 40.h,
                            child: ElevatedButton(
                              onPressed: storesController.zoomIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(),
                                padding: EdgeInsets.zero,
                              ),
                              child: Icon(Icons.add, size: 20),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            width: 40.w,
                            height: 40.h,
                            child: ElevatedButton(
                              onPressed: storesController.zoomOut,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(),
                                padding: EdgeInsets.zero,
                              ),
                              child: Icon(Icons.remove, size: 20),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Obx(
                () => ListView.builder(
                  itemCount: storesController.stores.length,
                  itemBuilder: (context, index) {
                    StoresModel store = storesController.stores[index];
                    return InkWell(
                      onTap: () {
                        storesController.selectedStore.value = store;

                        storesController.toggleStoreSelection(store);
                      },
                      child: Obx(
                        () => Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: storesController.selectedStores
                                      .contains(store)
                                  ? Colors.orangeAccent.shade200
                                  : Colors.grey,
                            ),
                          ),
                          margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Icon(Icons.store)],
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            store.storeLocation ?? '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // Text(store.storeAddress??""),
                                          Text("Generic Address 14, Kolhapur"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${store.distance.toString() ?? ''} km"),
                                      Text("away")
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Row(
                                children: [
                                  Text(
                                      "${store.dayOfWeek ?? ""}, ${store.startTime}, ${store.startTime}")
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                bottomNavItem(Icons.home, "Home"),
                bottomNavItem(Icons.restaurant_menu, "Menu"),
                bottomNavItem(Icons.store, "Stores"),
                bottomNavItem(Icons.shopping_bag, "Cart"),
              ],
            ),
            height: 50.h,
            width: double.infinity,
          )
        ],
      ),
    );
  }
}
