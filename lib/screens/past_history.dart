import 'package:first_choice_driver/common/app_image.dart';
import 'package:first_choice_driver/common/bottomnavigationbar.dart';
import 'package:first_choice_driver/common/sizedbox.dart';
import 'package:first_choice_driver/controller/ride_history.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/screens/ridedetail.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';

class PastHistory extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  const PastHistory({super.key, this.parentScaffoldKey});

  @override
  State<PastHistory> createState() => _PastHistoryState();
}

class _PastHistoryState extends State<PastHistory> {
  @override
  void initState() {
    context.read<RideHistoryProvider>().getridehistory(context: context);
    super.initState();
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  List<LatLng> polylineCoordinates = [];

  addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        width: 2,
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40.w,
        title: Text(
          "PAST BOOKING",
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PagesWidget(
                  currentTab: 0,
                ),
              ),
            );
          },
          child: Icon(
            Icons.close,
            color: AppColors.black,
          ),
        ),
      ),
      body:
          Consumer<RideHistoryProvider>(builder: (context, controller, child) {
        if (controller.isloading) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            OverlayLoadingProgress.start(
              context,
            );
          });
        } else if (controller.isempty) {
          return Center(
            child: Column(
              children: [
                const AppImage(
                  "assets/notfound.svg",
                ),
                Text(
                  "No booking found",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        } else if (controller.iserror) {
          OverlayLoadingProgress.stop();
        } else if (controller.rideHistory != null) {
          OverlayLoadingProgress.stop();

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<RideHistoryProvider>()
                  .getridehistory(context: context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  void makeLines() async {
                    await polylinePoints
                        .getRouteBetweenCoordinates(
                      "AIzaSyD6MRqmdjtnIHn7tyDLX-qsjreaTkuzSCY",
                      PointLatLng(
                          double.parse(controller.rideHistory!.bookings
                              .elementAt(index)
                              .pickupLocation
                              .lat),
                          double.parse(controller.rideHistory!.bookings
                              .elementAt(index)
                              .pickupLocation
                              .long)), //Starting LATLANG
                      PointLatLng(
                          double.parse(controller.rideHistory!.bookings
                              .elementAt(index)
                              .dropLocation
                              .last
                              .lat),
                          double.parse(controller.rideHistory!.bookings
                              .elementAt(index)
                              .dropLocation
                              .last
                              .long)), //End LATLANG
                      travelMode: TravelMode.driving,
                    )
                        .then((value) {
                      for (var point in value.points) {
                        polylineCoordinates
                            .add(LatLng(point.latitude, point.longitude));
                      }
                    }).then((value) {
                      addPolyLine();
                    });
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RideDetailScreen(
                            history: controller.rideHistory!.bookings
                                .elementAt(index),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: AppColors.greylight,
                          )),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100.h,
                            margin: const EdgeInsets.all(5),
                            width: 120.w,
                            child: GoogleMap(
                              polylines: Set<Polyline>.of(polylines.values),
                              zoomGesturesEnabled: true,
                              zoomControlsEnabled: false,
                              markers: <Marker>{
                                Marker(
                                  markerId: const MarkerId('marker_1'),
                                  draggable: false,
                                  position: LatLng(
                                      double.parse(controller
                                          .rideHistory!.bookings
                                          .elementAt(index)
                                          .pickupLocation
                                          .lat),
                                      double.parse(controller
                                          .rideHistory!.bookings
                                          .elementAt(index)
                                          .pickupLocation
                                          .long)),
                                  infoWindow: const InfoWindow(
                                    title: 'Marker Title',
                                    snippet: 'Marker Snippet',
                                  ),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueRed,
                                  ),
                                ),
                                Marker(
                                  markerId: const MarkerId('marker_2'),
                                  draggable: false,
                                  position: LatLng(
                                    double.parse(controller
                                        .rideHistory!.bookings
                                        .elementAt(index)
                                        .dropLocation
                                        .last
                                        .lat),
                                    double.parse(controller
                                        .rideHistory!.bookings
                                        .elementAt(index)
                                        .dropLocation
                                        .last
                                        .long),
                                  ),
                                  infoWindow: const InfoWindow(
                                    title: 'Marker Title',
                                    snippet: 'Marker Snippet',
                                  ),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueRed),
                                ),
                              },
                              gestureRecognizers: <Factory<
                                  OneSequenceGestureRecognizer>>{
                                Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                                ),
                              },
                              onMapCreated: (mapcontroller) {
                                mapcontroller.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                    LatLng(
                                      double.parse(controller
                                          .rideHistory!.bookings
                                          .elementAt(index)
                                          .dropLocation
                                          .last
                                          .lat),
                                      double.parse(controller
                                          .rideHistory!.bookings
                                          .elementAt(index)
                                          .dropLocation
                                          .last
                                          .lat),
                                    ),
                                    15,
                                  ),
                                );
                              },
                              compassEnabled: false,
                              myLocationButtonEnabled: false,
                              myLocationEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  double.parse(controller.rideHistory!.bookings
                                      .elementAt(index)
                                      .pickupLocation
                                      .lat),
                                  double.parse(controller.rideHistory!.bookings
                                      .elementAt(index)
                                      .pickupLocation
                                      .long),
                                ),
                                zoom: 15.0,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sizedBoxWithHeight(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  sizedBoxWithWidth(3),
                                  Icon(
                                    Icons.circle,
                                    color: Colors.black,
                                    size: 12.sp,
                                  ),
                                  Text(
                                    "  ${controller.rideHistory!.bookings.elementAt(index).bookingDate}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              sizedBoxWithHeight(10),
                              SizedBox(
                                width: 170.w,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.green,
                                      size: 15.sp,
                                    ),
                                    sizedBoxWithWidth(5),
                                    Flexible(
                                      child: Text(
                                        controller.rideHistory!.bookings
                                            .elementAt(index)
                                            .pickupLocation
                                            .address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              sizedBoxWithHeight(10),
                              SizedBox(
                                width: 170.w,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.pin_drop,
                                      color: Colors.red,
                                      size: 15.sp,
                                    ),
                                    sizedBoxWithWidth(5),
                                    Flexible(
                                      child: Text(
                                        controller.rideHistory!.bookings
                                            .elementAt(index)
                                            .dropLocation
                                            .first
                                            .address,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              sizedBoxWithHeight(10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  sizedBoxWithWidth(3),
                                  Icon(
                                    Icons.circle,
                                    color: Colors.black,
                                    size: 12.sp,
                                  ),
                                  sizedBoxWithWidth(10),
                                  Text(
                                    "  \$${controller.rideHistory!.bookings.elementAt(index).amount}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  RatingBar.builder(
                                    updateOnDrag: true,
                                    initialRating: double.parse(controller
                                        .rideHistory!.bookings
                                        .elementAt(index)
                                        .rating),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    ignoreGestures: true,
                                    allowHalfRating: true,
                                    unratedColor: Colors.grey,
                                    itemCount: 5,
                                    itemSize: 12.sp,
                                    itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                    ),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 10,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  sizedBoxWithWidth(20),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 12.sp,
                                  )
                                ],
                              ),
                              sizedBoxWithHeight(10),
                            ],
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .scale(),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10.h,
                  );
                },
                itemCount: controller.rideHistory!.bookings.length,
              ),
            ),
          );
        }

        return sizedBoxWithHeight(0);
      }),
    );
  }
}
