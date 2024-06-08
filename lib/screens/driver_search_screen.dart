import 'dart:async';
import 'dart:convert';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:first_choice_driver/common/app_image.dart';
import 'package:first_choice_driver/common/bottomnavigationbar.dart';
import 'package:first_choice_driver/common/sizedbox.dart';
import 'package:first_choice_driver/controller/driverstatus_provider.dart';
import 'package:first_choice_driver/controller/ride_provider.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/helpers/list_extentions.dart';
import 'package:first_choice_driver/model/riderequestnoti.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:map_launcher/map_launcher.dart' as ml;

import 'package:first_choice_driver/widgets/acceptrejectride.dart';
import 'package:first_choice_driver/widgets/driverarrived.dart';
import 'package:first_choice_driver/widgets/driverarriving.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import '../widgets/acceptaddress.dart';

class DriverSearch extends StatefulWidget {
  final bool isriderecieved;
  final RideRequestModel? rideRequestModel;
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  const DriverSearch({
    super.key,
    this.parentScaffoldKey,
    this.isriderecieved = false,
    this.rideRequestModel,
  });

  @override
  State<DriverSearch> createState() => _DriverSearchState();
}

class _DriverSearchState extends State<DriverSearch>
    with WidgetsBindingObserver {
  late AppLifecycleState appLifecycle;
  Set<Marker> markers = {};
  var polyLinesSet = <Polyline>{};

  Widget? errorPermssionWidget;
  @override
  // ADD THIS FUNCTION WITH A AppLifecycleState PARAMETER
  didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycle = state;
    setState(() {});

    if (state == AppLifecycleState.paused) {
      // IF YOUT APP IS IN BACKGROUND...
      // YOU CAN ADDED THE ACTION HERE
      rideProvider.audioPlayer.stop();
      print('My app is in background');
    } else if (state == AppLifecycleState.resumed) {
      if (rideProvider.isacceptvisible) {
        rideProvider.audioPlayer.resume();
      }
    }
  }

  LatLng? pickupLocation;
  Timer? _timer;
  final _controller = Completer<GoogleMapController>();

  RideProvider rideProvider = RideProvider();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    polyLinesSet = <Polyline>{};

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      rideProvider = Provider.of<RideProvider>(
        context,
        listen: false,
      );
      rideProvider.fetchlocatiocation(context: context).onError(
            (error, stackTrace) => errorPermssionWidget,
          );

      rideProvider.updatetoken(context: context);
      rideProvider.startLocationUpdates();
      getrideid();
      context.read<DriverStatusProvider>().getdriverstatus(
            context: context,
          );
      print("is ride received ${widget.isriderecieved}");
    });
    if (widget.isriderecieved) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        rideProvider.visibleaccept();
        rideProvider.playAlertSoundContinuously();
      });
    }

    if (mounted) {
      _timer = Timer.periodic(
        const Duration(seconds: 5),
        (timer) async {
          if (!mounted) {
            timer.cancel();
            return;
          }
          SharedPreferences preferences = await SharedPreferences.getInstance();

          if (preferences.getString("rideid") != null ||
              widget.rideRequestModel?.bookingNumber != null ||
              context.read<RideProvider>().rideid != null) {
            await context.read<RideProvider>().getridestatus(
                  context: context,
                );
          }
          _handleRideStatus(timer);

          if (context.read<RideProvider>().rideStatus != null) {
            if (context.read<RideProvider>().rideStatus!.status ==
                    "payment done" ||
                context.read<RideProvider>().rideStatus!.status == "cancel") {
              _timer!.cancel();
            }
          }
        },
      );
    }
    _handlecurrentbooking();

    super.initState();
  }

  @override
  void dispose() {
    rideProvider.positionStream?.cancel();
    _timer!.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RideProvider>(builder: (context, provider, child) {
      List<AddressString> droplocation = [];
      if (widget.rideRequestModel != null) {
        var addressstring = (jsonDecode(widget.rideRequestModel!.dropLocation));
        for (var i in addressstring) {
          droplocation.add(AddressString(
              address: i["address"], lat: i["lat"], long: i["long"]));
        }
      }
      if (provider.currentRide != null) {
        if (provider.currentRide!.status != "cancel" &&
            provider.currentRide!.status != "payment done") {
          for (var i in provider.currentRide!.dropLocation) {
            droplocation.add(
                AddressString(address: i.address, lat: i.lat, long: i.long));
          }
        }
      }
      double distance = calculateDistance(
        LatLng(
          rideProvider.currentPosition?.latitude ?? 00,
          rideProvider.currentPosition?.longitude ?? 00,
        ),
        LatLng(
          double.parse(
            rideProvider.currentRide?.dropLocation.last.lat ?? "00",
          ),
          double.parse(
            rideProvider.currentRide?.dropLocation.last.long ?? "00",
          ),
        ),
      );
      if (provider.isloading) {
        SchedulerBinding.instance.addPostFrameCallback(
          (timeStamp) {
            OverlayLoadingProgress.start(
              context,
            );
          },
        );
      } else if (provider.iserror) {
        OverlayLoadingProgress.stop();
      }

      return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Consumer<DriverStatusProvider>(
            builder: (context, controller, child) {
          if (controller.isloading) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              OverlayLoadingProgress.start(
                context,
              );
            });
          } else if (controller.iserror) {
            OverlayLoadingProgress.stop();
          } else if (controller.driverStatus != null) {
            OverlayLoadingProgress.stop();

            if (provider.acceptResponse != null) {
            } else if (provider.currentRide != null) {}
            List<String> dropaddresses = [];
            if (provider.currentRide != null) {
              var name = provider.currentRide?.dropLocation.map((e) {
                return e.address;
              });
              dropaddresses.add(name!.join(","));
            }
            return Scaffold(
              floatingActionButton: FloatingActionButton.small(
                backgroundColor: Colors.white,
                onPressed: () {
                  _controller.future.then((value) {
                    value.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                        bearing: 0,
                        target: LatLng(rideProvider.currentPosition!.latitude,
                            rideProvider.currentPosition!.longitude),
                        zoom: 17.0,
                      ),
                    ));
                  });
                },
                child: Icon(
                  Icons.my_location_rounded,
                  size: 20.sp,
                  color: AppColors.green,
                ),
              ),
              appBar: provider.isendridevisible
                  ? null
                  : AppBar(
                      leading: Padding(
                        padding: EdgeInsets.all(10.r),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PagesWidget(
                                  currentTab: 2,
                                ),
                              ),
                            );
                          },
                          child: const AppImage(
                            "assets/user.png",
                          ),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      elevation: 1,
                      centerTitle: true,
                      title: Padding(
                        padding: EdgeInsets.all(10.r),
                        child: AnimatedToggleSwitch<bool>.dual(
                          current: controller.isonline,
                          first: true,
                          second: false,
                          dif: 20.0,
                          borderColor: Colors.transparent,
                          borderWidth: 5.0,
                          height: 35,
                          innerColor:
                              controller.isonline ? Colors.green : Colors.red,
                          onChanged: (b) {
                            controller.changestatus(value: b, context: context);
                          },
                          indicatorColor: Colors.transparent,
                          indicatorSize: const Size(47, 25),
                          iconBuilder: (value) => value
                              ? const AppImage("assets/driver.svg")
                              : const AppImage("assets/driver.svg"),
                          textBuilder: (value) => value
                              ? Center(
                                  child: Text(
                                  'Online',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ))
                              : Center(
                                  child: Text(
                                  'Offline',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                        ),
                      ),
                    ),
              body: Stack(
                children: [
                  GoogleMap(
                    polylines: polyLinesSet,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    markers: markers,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                    onMapCreated: (mapcontroller) async {
                      if (_controller.isCompleted == false) {
                        _controller.complete(mapcontroller);
                      }

                      markers.add(
                        Marker(
                          draggable: false,
                          markerId: const MarkerId('driver_marker'),
                          position: getlatlong(),
                          infoWindow: const InfoWindow(
                            title: 'Driver location',
                            snippet: 'Marker Snippet',
                          ),
                          icon: await drivericon,
                        ),
                      );
                      mapcontroller.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          getlatlong(),
                          15,
                        ),
                      );
                    },
                    compassEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: getlatlong(),
                      zoom: 15.0,
                    ),
                  ),
                  //  const AppGoogleMap(),
                  Visibility(
                    visible: provider.isacceptvisible || provider.isarriving,
                    child: acceptaddress(
                            droplocation: widget.rideRequestModel == null &&
                                    provider.currentRide == null
                                ? []
                                : droplocation,
                            pickupLocation: widget.rideRequestModel == null &&
                                    provider.currentRide == null
                                ? ""
                                : widget.rideRequestModel?.pickupAddress ??
                                    provider
                                        .currentRide!.pickupLocation.address)
                        .animate()
                        .slideX(
                          duration: 1.seconds,
                        ),
                  ),
                  Visibility(
                    visible: provider.isacceptvisible,
                    child: acceptrejectride(
                            callback: () {
                              if (!controller.isonline) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: AppColors.green,
                                  content: const Text(
                                    "Please online first to accept ride \n\n",
                                  ),
                                  duration: const Duration(seconds: 2),
                                ));
                              } else {
                                context.read<RideProvider>().acceptride(
                                      context: context,
                                    );
                                _handleRideAccept();
                              }
                            },
                            context: context,
                            provider: controller,
                            rideRequestModel: widget.rideRequestModel)
                        .animate()
                        .slideY(begin: 1, duration: 1.seconds),
                  ),
                  Visibility(
                    visible: provider.isarriving,
                    child: provider.acceptResponse != null ||
                            provider.currentRide != null
                        ? arrivingwidget(
                            rideProvider: provider,
                            context: context,
                            rideRequestModel: widget.rideRequestModel,
                          ).animate().slideX(
                              duration: 500.milliseconds,
                            )
                        : const SizedBox(),
                  ),
                  Visibility(
                    visible: provider.isdriverarrive,
                    child: provider.driverArrived != null ||
                            provider.currentRide != null
                        ? driverarrived(
                            provider: provider,
                            rideid: provider.currentRide != null
                                ? provider.currentRide!.bookingId
                                : widget.rideRequestModel!.bookingNumber,
                            markers: markers,
                            context: context,
                            latitude: rideProvider.currentPosition != null
                                ? rideProvider.currentPosition!.latitude
                                    .toString()
                                : 00.toString(),
                          )
                        : const SizedBox(),
                  ),
                  Visibility(
                    visible: provider.isendridevisible,
                    child: Stack(
                      children: [
                        // SafeArea(
                        //   child: Container(
                        //     padding: EdgeInsets.only(
                        //       left: 10.w,
                        //       top: 8.h,
                        //       bottom: 8.h,
                        //     ),
                        //     margin: EdgeInsets.symmetric(
                        //       horizontal: 16.w,
                        //       vertical: 10.h,
                        //     ),
                        //     width: double.infinity,
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //         colors: [
                        //           AppColors.green,
                        //           AppColors.yellow,
                        //         ],
                        //       ),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: [
                        //             const Icon(
                        //               Icons.turn_left_outlined,
                        //               color: Colors.white,
                        //             ),
                        //             Text(
                        //               "700ft",
                        //               style: GoogleFonts.poppins(
                        //                 color: Colors.white,
                        //                 fontSize: 12.sp,
                        //                 fontWeight: FontWeight.w600,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         Text(
                        //           "  verve Senior Living",
                        //           style: GoogleFonts.poppins(
                        //               color: Colors.white,
                        //               fontSize: 18.sp,
                        //               fontWeight: FontWeight.w500),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              if (provider.rideStatus != null) {
                                ml.MapLauncher.showDirections(
                                  mapType: ml.MapType.google,
                                  destination: ml.Coords(
                                      double.parse(provider
                                          .rideStatus!.dropLocation.last.lat),
                                      double.parse(provider
                                          .rideStatus!.dropLocation.last.long)),
                                  extraParams: {"dir_action": "navigate"},
                                  waypoints: provider.rideStatus!.dropLocation
                                      .map((e) {
                                    return ml.Coords(
                                        double.parse(provider
                                            .rideStatus!.dropLocation.last.lat),
                                        double.parse(provider.rideStatus!
                                            .dropLocation.last.long));
                                  }).toList(),
                                );
                              } else {
                                ml.MapLauncher.showDirections(
                                    mapType: ml.MapType.google,
                                    extraParams: {"dir_action": "navigate"},
                                    directionsMode: ml.DirectionsMode.driving,
                                    destination: ml.Coords(
                                        double.parse(provider
                                            .startRide!.dropLocation.last.lat),
                                        double.parse(provider.startRide!
                                            .dropLocation.last.long)),
                                    waypoints: provider.startRide!.dropLocation
                                        .map((e) {
                                      return ml.Coords(
                                          double.parse(provider.startRide!
                                              .dropLocation.last.lat),
                                          double.parse(provider.startRide!
                                              .dropLocation.last.long));
                                    }).toList());
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => InBetweenRide(
                                //       startRide: startRide!,
                                //       markers: markers,
                                //     ),
                                //   ),
                                // );
                              }
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(bottom: 10.h, right: 20.w),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.navigation,
                                color: Colors.white,
                                size: 40.sp,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ) +
                                EdgeInsets.only(
                                  bottom: 30.h,
                                ),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Text(
                                //   "4 min 700ft",
                                //   style: GoogleFonts.poppins(
                                //       color: Colors.black,
                                //       fontSize: 12.sp,
                                //       fontWeight: FontWeight.w500),
                                // ),
                                Text(
                                  "Dropping Off",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                sizedBoxWithHeight(5),
                                InkWell(
                                  onTap: () {
                                    context.read<RideProvider>().endride(
                                          context: context,
                                          markers: markers,
                                        );
                                    // if (canArrive(distance)) {

                                    // } else {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(SnackBar(
                                    //     backgroundColor: AppColors.green,
                                    //     content: const Text(
                                    //       "Not Arrived at your Location yet \n\n",
                                    //     ),
                                    //     duration: const Duration(seconds: 2),
                                    //   ));
                                    // }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.green,
                                          AppColors.yellow,
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Drop Off",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }

          return const SizedBox();
        }),
      );
    });
  }

  LatLng getlatlong() {
    return LatLng(
        rideProvider.currentPosition != null
            ? rideProvider.currentPosition!.latitude
            : 56.1304,
        rideProvider.currentPosition != null
            ? rideProvider.currentPosition!.longitude
            : 106.3468);
  }

  Future<void> makePolylinesAndMarker({
    required PointLatLng startPoint,
    required PointLatLng endPoint,
  }) async {
    final polylinePoints = PolylinePoints();

    final resultant = await polylinePoints
        .getRouteBetweenCoordinates(
      "AIzaSyD6MRqmdjtnIHn7tyDLX-qsjreaTkuzSCY",
      startPoint,
      endPoint,
      travelMode: TravelMode.driving,
    )
        .catchError((E) {
      print(E);
      return PolylineResult();
    });

    final polylineCoordinates = <LatLng>[];

    for (var point in resultant.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }

    const id = PolylineId("poly");

    final polyline = Polyline(
      width: 2,
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
    );

    markers.add(
      Marker(
        draggable: false,
        markerId: const MarkerId('driver_marker'),
        position: polylineCoordinates.tryFirst ??
            LatLng(startPoint.latitude, startPoint.longitude),
        infoWindow: const InfoWindow(
          title: 'Driver location',
          snippet: 'Marker Snippet',
        ),
        icon: await drivericon,
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId('marker_1'),
        draggable: false,
        position: LatLng(endPoint.latitude, endPoint.longitude),
        infoWindow: const InfoWindow(
          title: 'Drop Location',
          snippet: 'Marker Snippet',
        ),
        icon: await dropicon,
      ),
    );

    polyLinesSet = {polyline};

    if (mounted) {
      setState(() {});
    }
  }

  initMarkers(
      {required LatLng pickupLocation, required LatLng dropLocation}) async {
    markers = {};

    markers.add(
      Marker(
        markerId: const MarkerId('marker_2'),
        draggable: false,
        position: pickupLocation,
        infoWindow: const InfoWindow(
          title: 'Pick up location',
          snippet: 'Marker Snippet',
        ),
        icon: await pickupicon,
      ),
    );
    // if (widget.dropExtralatlong != null) {
    //   markers.add(
    //     Marker(
    //       markerId: const MarkerId('marker_3'),
    //       draggable: false,
    //       position: widget.dropExtralatlong!,
    //       infoWindow: const InfoWindow(
    //         title: 'Secondary Drop Location',
    //         snippet: 'Marker Snippet',
    //       ),
    //       icon: await dropIcon,
    //     ),
    //   );
    // }
    markers.add(
      Marker(
        markerId: const MarkerId('marker_1'),
        draggable: false,
        position: dropLocation,
        infoWindow: const InfoWindow(
          title: 'Drop Location',
          snippet: 'Marker Snippet',
        ),
        icon: await dropicon,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Future<void> getrideid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (widget.rideRequestModel != null) {
      setState(() {
        context.read<RideProvider>().rideid =
            widget.rideRequestModel!.bookingNumber;
      });
      preferences.setString("rideid", widget.rideRequestModel!.bookingNumber);
    }
    if (widget.rideRequestModel == null) {
      setState(() {
        context.read<RideProvider>().rideid = preferences.getString("rideid");
      });
    }
  }

  Future<void> _handlecurrentbooking() async {
    await Provider.of<RideProvider>(context, listen: false)
        .currentride(context: context);
    if (!mounted) {
      return;
    }

    final resultant = context.read<RideProvider>().currentRide;

    if (resultant?.bookingId.isNotEmpty ?? false) {
      if (resultant?.status == 'payment done' ||
          resultant?.status == 'payment received' ||
          resultant?.status == "cancel") {
        return;
      }
    }
  }

  void _handlePaymentReceived() {
    _handlePaymentReceived();
  }

  void _handleRideArrived(int tick) async {
    final controller = await _controller.future;

    final bookingCtrl = context.read<RideProvider>();

    final driverLat = bookingCtrl.currentPosition?.latitude;
    final driverLong = bookingCtrl.currentPosition?.longitude;

    if (driverLat == null || driverLong == null) {
      return;
    }

// "lat":"12.9791681","long":"77.6437184
    // final testLtLng = LatLng(
    //   12.9791681 + tick / 1000 + 0.00005,
    //   77.6437184 + tick / 1000 + 0.00005,
    // );

    await makePolylinesAndMarker(
      startPoint: PointLatLng(
        driverLat,
        driverLong,
      ),
      endPoint: PointLatLng(
        double.parse(bookingCtrl.currentRide!.dropLocation.first.lat),
        double.parse(bookingCtrl.currentRide!.dropLocation.first.long),
      ),
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 15,
          target: LatLng(driverLat, driverLong),
        ),
      ),
    );
  }

  void _handleRideStatus(Timer timer) {
    if (mounted) {
      if (context.read<RideProvider>().currentRide?.status ==
          'payment received') {
        _handlePaymentReceived();
        return;
      }
    }
    if (mounted) {
      if (context.read<RideProvider>().currentRide?.status == 'complete') {
        _handleComplete();

        return;
      }
    }
    if (context.read<RideProvider>().currentRide?.status == 'arrived') {
      _handleRideArrived(timer.tick);
      initMarkers(
          pickupLocation: LatLng(
            double.parse(
                context.read<RideProvider>().currentRide!.pickupLocation.lat),
            double.parse(
              context.read<RideProvider>().currentRide!.pickupLocation.long,
            ),
          ),
          dropLocation: LatLng(
              double.parse(
                context
                    .read<RideProvider>()
                    .currentRide!
                    .dropLocation
                    .first
                    .long,
              ),
              double.parse(
                context
                    .read<RideProvider>()
                    .currentRide!
                    .dropLocation
                    .first
                    .long,
              )));

      return;
    }

    if (context.read<RideProvider>().currentRide?.status == 'start') {
      _handleRideStarted(timer.tick);
      initMarkers(
          pickupLocation: LatLng(
            double.parse(
                context.read<RideProvider>().currentRide!.pickupLocation.lat),
            double.parse(
              context.read<RideProvider>().currentRide!.pickupLocation.long,
            ),
          ),
          dropLocation: LatLng(
              double.parse(
                context
                    .read<RideProvider>()
                    .currentRide!
                    .dropLocation
                    .first
                    .long,
              ),
              double.parse(
                context
                    .read<RideProvider>()
                    .currentRide!
                    .dropLocation
                    .first
                    .long,
              )));

      return;
    }

    if (context.read<RideProvider>().currentRide?.status == 'accept') {
      _handleRideAccept();
      initMarkers(
          pickupLocation: LatLng(
            double.parse(
                context.read<RideProvider>().currentRide!.pickupLocation.lat),
            double.parse(
              context.read<RideProvider>().currentRide!.pickupLocation.long,
            ),
          ),
          dropLocation: LatLng(
              double.parse(
                context
                    .read<RideProvider>()
                    .currentRide!
                    .dropLocation
                    .first
                    .long,
              ),
              double.parse(
                context
                    .read<RideProvider>()
                    .currentRide!
                    .dropLocation
                    .first
                    .long,
              )));

      return;
    }
    if (context.read<RideProvider>().currentRide?.status == 'reject') {
      _navigateToHomePage();

      return;
    }
  }

  void _navigateToHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => PagesWidget(
            currentTab: 0,
          ),
        ),
        (_) => false);
  }

  void _handleRideAccept() async {
    final controller = await _controller.future;

    final bookingCtrl = context.read<RideProvider>();

    final driverLat = bookingCtrl.currentPosition?.latitude;
    final driverLong = bookingCtrl.currentPosition?.longitude;
    if (driverLat == null || driverLong == null) {
      return;
    }
// "lat":"12.9791681","long":"77.6437184
    // final testLtLng = LatLng(
    //   12.9791681 + tick / 1000 + 0.00005,
    //   77.6437184 + tick / 1000 + 0.00005,
    // );

    await makePolylinesAndMarker(
      startPoint: PointLatLng(
        driverLat,
        driverLong,
      ),
      endPoint: PointLatLng(
        double.parse(bookingCtrl.currentRide!.dropLocation.first.lat),
        double.parse(bookingCtrl.currentRide!.dropLocation.first.long),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 15,
          target: LatLng(
            driverLat,
            driverLong,
          ),
        ),
      ),
    );
  }

  void _handleRideStarted(int tick) async {
    final controller = await _controller.future;

    final bookingCtrl = context.read<RideProvider>();
    final driverLat = bookingCtrl.currentPosition?.latitude;
    final driverLong = bookingCtrl.currentPosition?.longitude;
    if (driverLat == null || driverLong == null) {
      return;
    }

// "lat":"12.9791681","long":"77.6437184
    // final testLtLng = LatLng(
    //   12.9791681 + tick / 1000 + 0.00005,
    //   77.6437184 + tick / 1000 + 0.00005,
    // );

    await makePolylinesAndMarker(
      startPoint: PointLatLng(
        driverLat,
        driverLong,
      ),
      endPoint: PointLatLng(
        double.parse(bookingCtrl.currentRide!.dropLocation.first.lat),
        double.parse(bookingCtrl.currentRide!.dropLocation.first.long),
      ),
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 15,
          target: LatLng(driverLat, driverLong),
        ),
      ),
    );
  }

  void _handleComplete() async {
    markers.remove(
      const Marker(markerId: MarkerId('driver_marker')),
    );

    final polylinePoints = PolylinePoints();

    final bookingCtrl = context.read<RideProvider>();

    final driverLat = bookingCtrl.currentPosition?.latitude;
    final driverLong = bookingCtrl.currentPosition?.longitude;

    if (driverLat == null || driverLong == null) {
      return;
    }

// "lat":"12.9791681","long":"77.6437184

    await makePolylinesAndMarker(
      startPoint: PointLatLng(
        driverLat,
        driverLong,
      ),
      endPoint: PointLatLng(
        double.parse(bookingCtrl.currentRide!.dropLocation.first.lat),
        double.parse(bookingCtrl.currentRide!.dropLocation.first.long),
      ),
    );
    final resultant = await polylinePoints
        .getRouteBetweenCoordinates(
      "AIzaSyD6MRqmdjtnIHn7tyDLX-qsjreaTkuzSCY",
      PointLatLng(
        double.parse(bookingCtrl.currentRide!.pickupLocation.lat),
        double.parse(bookingCtrl.currentRide!.pickupLocation.long),
      ),
      PointLatLng(
        double.parse(bookingCtrl.currentRide!.dropLocation.first.lat),
        double.parse(bookingCtrl.currentRide!.dropLocation.first.long),
      ),
      travelMode: TravelMode.driving,
    )
        .catchError((E) {
      print(E);
      return PolylineResult();
    });

    final polylineCoordinates = <LatLng>[];

    for (var point in resultant.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }

    const id = PolylineId("poly");

    final polyline = Polyline(
      width: 2,
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
    );

    polyLinesSet = {polyline};

    if (mounted) {
      setState(() {});
    }
  }
}

final drivericon = const AppImage(
  "assets/basil_user-solid.svg",
  height: 100,
  fit: BoxFit.cover,
  color: Colors.black,
  width: 100,
).toBitmapDescriptor(
  logicalSize: const Size(100, 100),
  imageSize: const Size(100, 100),
);

final pickupicon = const AppImage(
  "assets/pickup.svg",
  height: 100,
  width: 100,
  fit: BoxFit.cover,
).toBitmapDescriptor(
  logicalSize: const Size(100, 100),
  imageSize: const Size(100, 100),
);

final dropicon = const AppImage(
  "assets/drop.svg",
  height: 100,
  fit: BoxFit.cover,
  width: 100,
).toBitmapDescriptor(
  logicalSize: const Size(100, 100),
  imageSize: const Size(100, 100),
);

class AddressString {
  final String address;
  final String lat;
  final String long;
  AddressString({
    required this.address,
    required this.lat,
    required this.long,
  });
}
