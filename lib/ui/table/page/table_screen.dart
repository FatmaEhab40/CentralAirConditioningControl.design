import 'package:design/models/models.dart';
import 'package:design/ui/table/manager/table_cubit.dart';
import 'package:design/ui/table/manager/table_state.dart';
import 'package:design/ui/table/page/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:multiselect/multiselect.dart';

import 'delete_screen.dart';
import 'edit_screen.dart';

final cubit = TableCubit();

class Periods {
  String duration = "";
  String id = "";
  String userId = ConstantVar.auth.currentUser!.uid;
  Periods(this.duration, this.id);

  Map<String, dynamic> toMap() {
    return {
      "duration": duration,
      "id": id,
      "userId": userId,
    };
  }

  Periods.fromMap(Map<dynamic, dynamic> data) {
    duration = data['duration'];
    id = data['id'];
    userId = data['userId'];
  }

  Map<String, dynamic> toJson() {
    return {
      "duration": duration,
      "id": id,
      "userId": userId,
    };
  }
}

class Rooms {
  String name = "";
  String id = "";
  String userId = ConstantVar.auth.currentUser!.uid;
  Rooms(this.name, this.id);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "id": id,
      "userId": userId,
    };
  }

  Rooms.fromMap(Map<dynamic, dynamic> data) {
    name = data['name'];
    id = data['id'];
    userId = data['userId'];
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "userId": userId,
    };
  }
}

class MySchedule {
  List<String> days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  List<Periods> periods = [];
  List<Rooms> rooms = [];
  Map<String, Map<String, List<List<dynamic>>>> schedule = {
    "days": {"periods": [], "rooms": []},
    "periods": {"days": [], "rooms": []},
    "rooms": {"days": [], "periods": []},
  };

  void saveSchedule() {
    // Save the days map
    ConstantVar.firestore.collection('schedule').add({
      'name': 'Monday',
      'periods': periods.map((period) => period.toJson()).toList(),
      'rooms': rooms.map((room) => room.toJson()).toList(),
    }).then((docRef) {
      // Save the periods
      for (var period in periods) {
        final periodStore=period.toJson();
        docRef.collection('periods').add(periodStore);
      }

      // Save the rooms
      for (var room in rooms) {
        final roomStore=room.toJson();
        docRef.collection('rooms').add(roomStore);
      }
    });
  }

  void updateSelectedRooms(
      int dayIndex, int periodIndex, List<Rooms> newRooms) {
    schedule["days"]?["rooms"]![dayIndex][periodIndex] =
        newRooms.map((e) => e.toString()).toList();
    schedule["periods"]?["rooms"]![periodIndex][dayIndex] =
        newRooms.map((e) => e.toString()).toList();
    for (var room in newRooms) {
      schedule["rooms"]?["days"]![rooms.indexOf(room)][dayIndex] =
          newRooms.map((e) => e.toString()).toList();
      schedule["rooms"]?["periods"]![rooms.indexOf(room)][periodIndex] =
          newRooms.map((e) => e.toString()).toList();
    }
  }
}

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  late MySchedule mySchedule;
  List<Rooms> selectedRooms = [];
  final periodController = TextEditingController();
  final roomController = TextEditingController();
  final containerHeight = 35.sp;
  final containerWidth = 45.sp;

  @override
  void initState() {
    super.initState();
    mySchedule = MySchedule();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<TableCubit, TableState>(
        buildWhen: (previous, current) {
          return current is GetRoomsSuccessState ||
              current is DeleteRoomsSuccessState ||
              current is AddRoomsSuccessState ||
              current is UpdateRoomsSuccessState ||
              current is GetPeriodsSuccessState ||
              current is DeletePeriodsSuccessState ||
              current is AddPeriodsSuccessState ||
              current is UpdatePeriodsSuccessState;
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: ConstantVar.backgroundPage,
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: Colors.brown,
              ),
              title: GradientText(
                'Schedule',
                style: GoogleFonts.eagleLake(fontSize: 20.sp),
                gradientType: GradientType.linear,
                colors: ConstantVar.gradientList,
              ),
              actions: [
                PopupMenuButton(
                    icon: const Icon(Icons.menu, color: Colors.brown),
                    color: ConstantVar.backgroundPage,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: GradientText(
                            'Add',
                            colors: ConstantVar.gradientList,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: GradientText(
                            'Edit',
                            colors: ConstantVar.gradientList,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: GradientText(
                            'Delete',
                            colors: ConstantVar.gradientList,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                  value: cubit, child: const AddScreen()),
                            )).then((value) => (value) {
                              cubit.getPeriods();
                              cubit.getRooms();
                            });
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => const AddScreen(),));
                      } else if (value == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditScreen(),
                            ));
                      } else if (value == 2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeleteScreen(),
                            ));
                      }
                    }),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //period and day
                          SizedBox(
                            height: containerHeight,
                            width: containerWidth,
                            child: CustomPaint(
                                painter: RectanglePainter(),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0.sp),
                                        child: Text("Period",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp)),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0.sp),
                                        child: Text("Day",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp)),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Divider(
                              height: 5.sp, color: ConstantVar.backgroundPage),
                          //day
                          ...List.generate(
                            mySchedule.days.length,
                            (index) => Column(
                              children: [
                                Container(
                                  height: containerHeight,
                                  width: containerWidth,
                                  decoration: const BoxDecoration(
                                    color: ConstantVar.backgroundContainer,
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      mySchedule.days[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.sp),
                                    ),
                                  ),
                                ),
                                Divider(
                                    height: 5.sp,
                                    color: ConstantVar.backgroundPage),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 5.sp),
                      // SizedBox(
                      //   width: 250.sp,
                      //   height: 120.sp,
                      //   child:
                      //   Wrap(
                      //     spacing: 5.sp,
                      //     runSpacing: 5.sp,
                      //     children:
                      //     List.generate(
                      //       cubit.periods.length,
                      //       (periodIndex) {
                      //         return
                      //   Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             //period
                      //             SizedBox(
                      //               height: containerHeight,
                      //               width: containerWidth,
                      //               child:
                      //               Row(
                      //                 children: [
                      //                    Flexible(
                      //                        child:
                      //               ListView.builder(
                      //                  scrollDirection: Axis.horizontal,
                      //                   itemCount: cubit.periods.length,
                      //                   itemBuilder: (context, index) {
                      //                     return Row(
                      //                       children: [
                      //                         Container(
                      //                          height: containerHeight,
                      //                           width: containerWidth,
                      //                           decoration: const BoxDecoration(
                      //                             color: ConstantVar
                      //                                 .backgroundContainer,
                      //                             shape: BoxShape.rectangle,
                      //                           ),
                      //                           child: Center(
                      //                             child: Text(
                      //                               cubit.periods[index].duration,
                      //                               textAlign: TextAlign.center,
                      //                               style: TextStyle(
                      //                                   color: Colors.white,
                      //                                   fontSize: 19.sp),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                         SizedBox(width: 5.sp)
                      //                       ],
                      //                     );
                      //                   },
                      //                 ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             //room
                      //             SizedBox(
                      //               height: 135.sp,
                      //               width: 47.sp,
                      //               child: Column(
                      //                 mainAxisAlignment:
                      //                 MainAxisAlignment.start,
                      //                 children: [
                      //                   SingleChildScrollView(
                      //                     scrollDirection: Axis.vertical,
                      //                     child: Wrap(
                      //                       spacing: 5.sp,
                      //                       runSpacing: 5.sp,
                      //                       children: List.generate(
                      //                         mySchedule.days.length,
                      //                             (dayIndex) {
                      //                           return SizedBox(
                      //                             height: containerHeight,
                      //                             width: 55.sp,
                      //                             child: Row(
                      //                               children: [
                      //                                 Expanded(
                      //                                   child: SizedBox(
                      //                                     height: 42.sp,
                      //                                     width: containerWidth,
                      //                                     child:
                      //                                     DropDownMultiSelect(
                      //                                       selectedValues:
                      //                                       selectedRooms,
                      //                                       selected_values_style:
                      //                                       const TextStyle(
                      //                                           color: Colors
                      //                                               .brown),
                      //                                       onChanged:
                      //                                           (List<Rooms>
                      //                                       x) {
                      //                                         mySchedule.updateSelectedRooms(
                      //                                             dayIndex,
                      //                                             periodIndex,
                      //                                             x); // pass the day index and period index
                      //                                         cubit
                      //                                             .updateSelectedRooms(
                      //                                             x);
                      //                                       },
                      //                                       options:
                      //                                       cubit.rooms,
                      //                                       decoration:
                      //                                       InputDecoration(
                      //                                         iconColor:
                      //                                         Colors.brown,
                      //                                         label: const Text(
                      //                                           'Select Rooms',
                      //                                           textAlign:
                      //                                           TextAlign
                      //                                               .start,
                      //                                           style: TextStyle(
                      //                                               color: Colors
                      //                                                   .brown),
                      //                                         ),
                      //                                         focusedBorder: OutlineInputBorder(
                      //                                             borderSide: BorderSide(
                      //                                                 color: const Color(
                      //                                                     0xFF3E2723),
                      //                                                 width: 5
                      //                                                     .sp)),
                      //                                         labelStyle: const TextStyle(
                      //                                             color: Colors
                      //                                                 .brown,
                      //                                             fontWeight:
                      //                                             FontWeight
                      //                                                 .bold),
                      //                                         enabledBorder:
                      //                                         OutlineInputBorder(
                      //                                           borderSide: BorderSide(
                      //                                               color: const Color(
                      //                                                   0xFF3E2723),
                      //                                               width:
                      //                                               5.sp),
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                                 SizedBox(width: 5.sp),
                      //                               ],
                      //                             ),
                      //                           );
                      //                         },
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //    ),
                      //   ),
                      // ),

                      SizedBox(
                        width: 250.sp,
                        height: 120.sp * cubit.periods.length,
                        child: Column(
                          children: List.generate(
                            cubit.periods.length,
                                (periodIndex) {
                              return Expanded(
                                child: Row(
                                  children: List.generate(
                                    mySchedule.days.length,
                                        (dayIndex) {
                                      return SizedBox(
                                        width: 55.sp,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // period
                                            Container(
                                              height: containerHeight,
                                              width: containerWidth,
                                              decoration: const BoxDecoration(
                                                color: ConstantVar.backgroundContainer,
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  cubit.periods[periodIndex].duration,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white, fontSize: 19.sp),
                                                ),
                                              ),
                                            ),
                                            // room
                                            SizedBox(
                                              height: 135.sp,
                                              child: DropDownMultiSelect(
                                                selectedValues: selectedRooms,
                                                selected_values_style: const TextStyle(color: Colors.brown),
                                                onChanged: (List<Rooms> x) {
                                                  mySchedule.updateSelectedRooms(dayIndex, periodIndex, x); // pass the day index and period index
                                                  cubit.updateSelectedRooms(x);
                                                },
                                                options: cubit.rooms,
                                                decoration: InputDecoration(
                                                  iconColor: Colors.brown,
                                                  label: const Text(
                                                    'Select Rooms',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(color: Colors.brown),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: const Color(0xFF3E2723),
                                                          width: 5.sp)),
                                                  labelStyle: const TextStyle(
                                                      color: Colors.brown,
                                                      fontWeight: FontWeight.bold),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: const Color(0xFF3E2723), width: 5.sp),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = ConstantVar.backgroundContainer
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final crossLine = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Draw the rectangle
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Draw the cross line
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), crossLine);
    //canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), crossLine);
  }

  @override
  bool shouldRepaint(RectanglePainter oldDelegate) => false;
}
