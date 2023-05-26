import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:geolocator/geolocator.dart';

import '../../../constants.dart';
import '../../data/data_source/call_data.dart';
import '../../data/data_source/get_appoitment_data.dart';
import '../../data/data_source/get_current_location.dart';

import '../widget/common_button.dart';
import '../widget/show_text.dart';
import 'map_show.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;

import 'package:intl/intl.dart';

import '../../data/data_source/change_status_data.dart';

class AppoitmentDetailScreen extends StatefulWidget {
  final appoitmentId;
  const AppoitmentDetailScreen({
    Key? key,
    required this.appoitmentId,
  }) : super(key: key);

  @override
  State<AppoitmentDetailScreen> createState() => _AppoitmentDetailScreenState();
}

class _AppoitmentDetailScreenState extends State<AppoitmentDetailScreen> {
  String dropdownValue = 'Ongoing';

  List<String> dropdownItems = [
    'Ongoing',
    'Completed',
  ];
  dynamic selectedAppoitmentData;
  getSelectedAppotment() async {
    var appoitment = Appoitment();
    dynamic appoitmentData =
        await appoitment.getAppoitment(widget.appoitmentId.toString());
    setState(() {
      selectedAppoitmentData = appoitmentData;
    });
    print(selectedAppoitmentData);
  }

  lounchMap() {
    mapLauncher.MapLauncher.showDirections(
      mapType: mapLauncher.MapType.google,
      origin: mapLauncher.Coords(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      ),
      originTitle: 'Your Locations',
      directionsMode: mapLauncher.DirectionsMode.driving,
      destinationTitle: 'Destination Location',
      destination: mapLauncher.Coords(
        selectedAppoitmentData['geoLocation']['lat'].toDouble(),
        selectedAppoitmentData['geoLocation']['long'].toDouble(),
      ),
    );
  }

  Position? _currentPosition;
  var hasPermission;
  Future<void> getCurrentLocarion() async {
    var location = Location();
    hasPermission = await location.handleLocationPermission(context: context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      lounchMap();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    super.initState();
    getSelectedAppotment();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedAppoitmentData != null) {
      final DateTime now =
          DateTime.parse(selectedAppoitmentData['date'].toString());
      final DateFormat formatter = DateFormat('dd-MMM-yyyy');
      final String formatted = formatter.format(now);
      print(formatted);
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: selectedAppoitmentData == null
              ? Text('')
              : Text(selectedAppoitmentData != null
                  ? selectedAppoitmentData['name'].toString()
                  : ''),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShowText(
                      label: 'Date:',
                      detail: formatted.toString(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    ShowText(
                      label: 'Slot:',
                      detail: selectedAppoitmentData['time'].toString(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    ShowText(
                      label: 'Email:',
                      detail: selectedAppoitmentData['email'].toString(),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShowText(
                      label: 'Mobile:',
                      detail: selectedAppoitmentData['mobile'].toString(),
                    ),
                  ],
                ),
                selectedAppoitmentData['healthPackage'] != null
                    ? SizedBox(
                        height: 15,
                      )
                    : SizedBox(),
                selectedAppoitmentData['healthPackage'] != null
                    ? Row(
                        children: [
                          ShowText(
                            label: 'Health Package:',
                            detail: selectedAppoitmentData['healthPackage']
                                    ['name']
                                .toString(),
                          ),
                        ],
                      )
                    : SizedBox(),
                selectedAppoitmentData['tests']
                        .map((e) => e['name'].toString())
                        .isNotEmpty
                    ? SizedBox(
                        height: 15,
                      )
                    : SizedBox(),
                selectedAppoitmentData['tests']
                        .map((e) => e['name'].toString())
                        .isNotEmpty
                    ? Row(
                        children: [
                          ShowText(
                            label: 'Test:',
                            detail: selectedAppoitmentData['tests']
                                .map((e) => e['name'].toString())
                                .toString(),
                          ),
                        ],
                      )
                    : SizedBox(),
                selectedAppoitmentData['tests']
                        .map((e) => e['name'].toString())
                        .toString()
                        .isNotEmpty
                    ? SizedBox(
                        height: 15,
                      )
                    : SizedBox(),
                Row(
                  children: [
                    ShowText(
                      label: 'Address:',
                      detail: selectedAppoitmentData['address'].toString(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                (selectedAppoitmentData?['images'] != null &&
                        selectedAppoitmentData?['images']?.length == 0)
                    ? SizedBox()
                    : Container(
                        height: 100,
                        width: 100,
                        child: FullScreenWidget(
                          backgroundColor: backgroundColor,
                          backgroundIsTransparent: true,
                          child: Center(
                            child: Hero(
                              tag: "nonTransparent",
                              child: ClipRRect(
                                //borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  selectedAppoitmentData['images'][0]['url']
                                      .toString(),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                Container(
                  height: 300,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.3,
                      color: Colors.black,
                    ),
                  ),
                  child: GoogleMapScreen(
                    latitude:
                        selectedAppoitmentData['geoLocation']['lat'].toDouble(),
                    longitude: selectedAppoitmentData['geoLocation']['long']
                        .toDouble(),
                  ),
                ),
                selectedAppoitmentData['status'] == 'Completed'
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: SizedBox(
                              height: 40,
                              width: 150,
                              child: CommonButton(
                                buttonName: 'Get Direction',
                                clr: primaryColor,
                                onPresse: () async {
                                  getCurrentLocarion();
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: SizedBox(
                              height: 40,
                              width: 150,
                              child: CommonButton(
                                buttonName: 'Make Call',
                                clr: primaryColor,
                                onPresse: () async {
                                  var call = Call();
                                  await call.makeCall(
                                      selectedAppoitmentData['mobile']
                                          .toString());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                selectedAppoitmentData['status'] == 'Completed'
                    ? SizedBox()
                    : Text(
                        'Select Your Status:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                SizedBox(
                  height: 10,
                ),
                selectedAppoitmentData['status'] == 'Completed'
                    ? SizedBox()
                    : Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              //dropdownColor: Colors.greenAccent,
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: dropdownItems
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            height: 40,
                            width: 100,
                            child: CommonButton(
                              buttonName: 'Update',
                              clr: dropdownValue == 'Ongoing' &&
                                      selectedAppoitmentData['status'] ==
                                          'Ongoing'
                                  ? Colors.grey
                                  : primaryColor,
                              onPresse: () {
                                dropdownValue == 'Ongoing' &&
                                        selectedAppoitmentData['status'] ==
                                            'Ongoing'
                                    ? null
                                    : setState(() {
                                        changeStatus(
                                            dropdownValue, widget.appoitmentId);
                                        Navigator.pop(context);
                                      });
                              },
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: Container(
              color: backgroundColor,
              child: Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
