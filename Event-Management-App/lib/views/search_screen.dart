import 'package:event_booking_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/events_controller.dart';
import '../controllers/search_controller.dart' as ctrl;
import '../models/event.dart';
import '../utils/exports/manager_exports.dart';
import '../utils/exports/widgets_exports.dart';

import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String routeName = '/searchEventScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = Get.put(ctrl.SearchController());
  final eventController = Get.put(EventController());
  @override
  void dispose() {
    Get.delete<SearchController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.scaffoldBackgroundColor,
      body: Obx(
        () => SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: MarginManager.marginM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Txt(
                  textAlign: TextAlign.start,
                  text: StringsManager.searchEventTxt,
                  fontWeight: FontWeightManager.bold,
                  fontSize: FontSize.headerFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomSearchWidget(
                  onFieldSubmit: (value) {
                    searchController.searchEvent(value.trim());
                  },
                ),
                searchController.searchedEvents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: SizeManager.sizeXL * 7),
                            SvgPicture.asset(
                              'assets/images/search.svg',
                              height: SizeManager.splashIconSize,
                              width: SizeManager.splashIconSize,
                              fit: BoxFit.scaleDown,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Txt(
                              textAlign: TextAlign.center,
                              text: StringsManager.searchNowEventTxt,
                              fontWeight: FontWeightManager.bold,
                              fontSize: FontSize.titleFontSize,
                              fontFamily: FontsManager.fontFamilyPoppins,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchController.searchedEvents.length,
                        itemBuilder: (context, index) {
                          Event event = searchController.searchedEvents[index];
                          return isEventOngoing(event)
                              ? InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomBottomSheet(
                                              event: event);
                                        });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorManager.cardBackGroundColor,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: MarginManager.marginXS),
                                    width: double.infinity,
                                    height: 120,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 140,
                                          height: 150,
                                          child: Image.network(
                                            event.posterUrl,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      ColorManager.blackColor,
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return const Icon(Icons.error);
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Txt(
                                                text:
                                                    '${event.startDate} at ${event.startTime}',
                                                useOverflow: true,
                                                textAlign: TextAlign.start,
                                                fontWeight:
                                                    FontWeightManager.regular,
                                                fontSize:
                                                    FontSize.subTitleFontSize,
                                                fontFamily: FontsManager
                                                    .fontFamilyPoppins,
                                                color: ColorManager.blackColor,
                                              ),
                                              Txt(
                                                text: event
                                                    .name.capitalizeFirstOfEach,
                                                textAlign: TextAlign.start,
                                                fontWeight:
                                                    FontWeightManager.bold,
                                                fontSize:
                                                    FontSize.titleFontSize *
                                                        0.7,
                                                fontFamily: FontsManager
                                                    .fontFamilyPoppins,
                                                color: ColorManager.blackColor,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  event.organizerId ==
                                                          firebaseAuth
                                                              .currentUser!.uid
                                                      ? const Chip(
                                                          label: Txt(
                                                            text: "Organizer",
                                                            color: Colors.white,
                                                          ),
                                                          backgroundColor:
                                                              ColorManager
                                                                  .primaryColor,
                                                        )
                                                      : FavoriteIcon(
                                                          event: event,
                                                          eventController:
                                                              eventController,
                                                        ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container();
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isEventOngoing(Event event) {
    final endDate = DateFormat("dd-MM-yyyy").parse(event.endDate);
    final endTime =
        TimeOfDay.fromDateTime(DateFormat("h:mm a").parse(event.endTime))
            .toDateTime();
    final now = DateTime.now();

    return endDate.isAfter(now) ||
        (endDate.isAtSameMomentAs(now) && endTime.isAfter(now));
  }
}
