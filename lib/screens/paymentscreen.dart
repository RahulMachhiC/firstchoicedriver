import 'package:first_choice_driver/common/app_image.dart';
import 'package:first_choice_driver/controller/ride_provider.dart';
import 'package:first_choice_driver/helpers/colors.dart';
import 'package:first_choice_driver/model/endride.dart';
import 'package:first_choice_driver/screen_config.dart';
import 'package:first_choice_driver/size_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final Set<Marker>? markers;

  final EndRide? endRide;
  const PaymentScreen({
    super.key,
    this.markers,
    this.endRide,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // late List<bool> _isChecked;
  TextEditingController cashController = TextEditingController(text: "0");
  TextEditingController visaController = TextEditingController();
  TextEditingController masterController = TextEditingController();
  TextEditingController amexController = TextEditingController();
  TextEditingController debitController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController punchController = TextEditingController(text: "0");
  TextEditingController giftController = TextEditingController(text: "0");
  TextEditingController barterController = TextEditingController();

  List<PaymentOptions> paymentoptions = [];
  List<String> paymentid = [];
  List<String> cardnumber = [];
  @override
  void initState() {
    paymentoptions = [
      PaymentOptions(
          isSelected: false,
          id: "1",
          type: 'Cash',
          logo: "assets/cash.svg",
          maxlimit: 0,
          isvivsble: false,
          textEditingController: cashController),
      PaymentOptions(
          id: "2",
          isSelected: false,
          type: 'Visa',
          isvivsble: true,
          logo: "assets/visa.svg",
          maxlimit: 4,
          textEditingController: visaController),
      PaymentOptions(
          id: "3",
          type: 'Master Card',
          isSelected: false,
          isvivsble: true,
          logo: "assets/mastercard.svg",
          maxlimit: 4,
          textEditingController: masterController),
      PaymentOptions(
          id: "4",
          type: 'Amex',
          isvivsble: true,
          isSelected: false,
          logo: "assets/amex.svg",
          maxlimit: 4,
          textEditingController: amexController),
      PaymentOptions(
          id: "5",
          isSelected: false,
          type: 'Debit',
          logo: "assets/debit-card.svg",
          isvivsble: true,
          maxlimit: 4,
          textEditingController: debitController),
      PaymentOptions(
          id: "6",
          type: 'Account',
          isSelected: false,
          isvivsble: true,
          logo: "assets/Account.svg",
          maxlimit: 100,
          textEditingController: accountController),
      PaymentOptions(
          isSelected: false,
          id: "7",
          type: 'Punch Cards',
          logo: "assets/punch.svg",
          maxlimit: 0,
          isvivsble: false,
          textEditingController: punchController),
      PaymentOptions(
          isSelected: false,
          id: "8",
          type: 'Gift Cards/Coupons',
          logo: "assets/gift.svg",
          isvivsble: false,
          maxlimit: 0,
          textEditingController: giftController),
      PaymentOptions(
          id: "9",
          type: 'Barterpay',
          isSelected: false,
          logo: "assets/Debit.svg",
          isvivsble: true,
          maxlimit: 7,
          textEditingController: barterController)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil()
      ..init(
        context,
      );
    return Scaffold(
        backgroundColor: AppColors.appColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 40.w,
          title: Text(
            "Payment Options",
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          // leading: InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => PagesWidget(
          //           currentTab: 0,
          //         ),
          //       ),
          //     );
          //   },
          //   child: Icon(
          //     Icons.close,
          //     color: AppColors.black,
          //   ),
          // ),
        ),
        body: Consumer<RideProvider>(builder: (context, controller, child) {
          if (controller.isloading) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              OverlayLoadingProgress.start(context);
            });
          } else if (controller.isloading == false) {
            OverlayLoadingProgress.stop();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment Options",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        fillColor: MaterialStateColor.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return AppColors.green;
                          }
                          return AppColors.black;
                        }),
                        activeColor: AppColors.green,
                        selectedTileColor: AppColors.green,
                        tileColor: AppColors.appColor,
                        value: paymentoptions[index].isSelected,
                        // groupValue: selectedPaymentOptionIndex,
                        onChanged: (value) {
                          setState(
                            () {
                              paymentoptions[index].isSelected = value!;
                            },
                          );
                          // setState(() {
                          //   selectedpaymentType =
                          //       paymentoptions.elementAt(index).type;
                          //   selectedPaymentOptionIndex = value as int;
                          // });
                        },
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppImage(
                              paymentoptions.elementAt(index).logo,
                              height: 30.h,
                            ),
                            SizedBox(
                              width: 15.h,
                            ),
                            Text(
                              paymentoptions[index].type,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Visibility(
                              visible:
                                  paymentoptions.elementAt(index).isSelected,
                              child: Visibility(
                                visible:
                                    paymentoptions.elementAt(index).isvivsble,
                                child: Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: paymentoptions
                                        .elementAt(index)
                                        .textEditingController,
                                    maxLength: 4,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText:
                                          "Enter ${paymentoptions.elementAt(index).type} Number",
                                      hintStyle: GoogleFonts.poppins(
                                        color: AppColors.grey500,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppColors.grey500,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppColors.grey500,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppColors.grey500,
                                        ),
                                      ),
                                      // prefixIcon: Icon(
                                      //   Icons.attach_money,
                                      //   color: AppColors.grey500,
                                      // ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 8.h,
                                      ),
                                      filled: true,
                                      fillColor: AppColors.greylight,
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppColors.grey500,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppColors.grey500,
                                        ),
                                      ),
                                      errorStyle: GoogleFonts.poppins(
                                        color: AppColors.grey500,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      counterText: "",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox();
                    },
                    itemCount: paymentoptions.length,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controller.tipcontroller,
                          maxLength: 4,
                          decoration: InputDecoration(
                            hintText: "Enter Tip Amount",
                            hintStyle: GoogleFonts.poppins(
                              color: AppColors.grey500,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.grey500,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.grey500,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.grey500,
                              ),
                            ),
                            // prefixIcon: Icon(
                            //   Icons.attach_money,
                            //   color: AppColors.grey500,
                            // ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 8.h,
                            ),
                            filled: true,
                            fillColor: AppColors.greylight,
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.grey500,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.grey500,
                              ),
                            ),
                            errorStyle: GoogleFonts.poppins(
                              color: AppColors.grey500,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            counterText: "",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      InkWell(
                        onTap: () {
                          if (controller.tipcontroller.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: AppColors.green,
                              content: const Text(
                                "Please Enter Tip Amount\n\n",
                              ),
                              duration: const Duration(seconds: 2),
                            ));
                          } else {
                            controller.addridetip(context: context);
                          }
                        },
                        child: Container(
                          height: 45.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Add tip",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InkWell(
                    onTap: () {
                      if (paymentoptions
                          .every((element) => !element.isSelected)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.green,
                            content: Text(
                                "Please Select Atleast One Payment Option"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else if (paymentoptions.elementAt(1).isSelected &&
                          paymentoptions
                              .elementAt(1)
                              .textEditingController
                              .text
                              .isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.green,
                            content: Text(
                                "Please Enter ${paymentoptions.elementAt(1).type} Number"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else if (paymentoptions.elementAt(2).isSelected &&
                          paymentoptions
                              .elementAt(2)
                              .textEditingController
                              .text
                              .isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.green,
                            content: Text(
                                "Please Enter ${paymentoptions.elementAt(2).type} Number"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else if (paymentoptions.elementAt(3).isSelected &&
                          paymentoptions
                              .elementAt(3)
                              .textEditingController
                              .text
                              .isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.green,
                            content: Text(
                                "Please Enter ${paymentoptions.elementAt(3).type} Number"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else if (paymentoptions.elementAt(4).isSelected &&
                          paymentoptions
                              .elementAt(4)
                              .textEditingController
                              .text
                              .isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.green,
                            content: Text(
                                "Please Enter ${paymentoptions.elementAt(4).type} Number"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else if (paymentoptions.elementAt(5).isSelected &&
                          paymentoptions
                              .elementAt(5)
                              .textEditingController
                              .text
                              .isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.green,
                            content: Text(
                                "Please Enter ${paymentoptions.elementAt(5).type} Number"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else if (paymentoptions.elementAt(8).isSelected &&
                          paymentoptions
                              .elementAt(8)
                              .textEditingController
                              .text
                              .isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.green,
                            content: Text(
                                "Please Enter ${paymentoptions.elementAt(8).type} Number"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else {
                        print("API Caalin");
                        for (var i in paymentoptions) {
                          if (i.isSelected) {
                            paymentid.add(i.id);
                            cardnumber.add(i.textEditingController.text);
                          }
                        }

                        controller.updatepayment(
                          context: context,
                          markers: widget.markers!,
                          paymentid: paymentid,
                          endRide: widget.endRide!,
                          cardNumber: cardnumber,
                        );
                      }
                    },
                    child: Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Apply",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}

class PaymentOptions {
  final String id;
  final String type;
  final String logo;
  bool isSelected;
  final bool isvivsble;
  final TextEditingController textEditingController;
  final int maxlimit;
  PaymentOptions({
    required this.id,
    required this.isvivsble,
    required this.textEditingController,
    required this.type,
    required this.isSelected,
    required this.maxlimit,
    required this.logo,
  });
}
