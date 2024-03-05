import 'package:design/models/models.dart';
import 'package:design/ui/table/page/table_screen.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';



List<DropDownValueModel> dropDownListPeriods = cubit.periods
    .map((period) =>
    DropDownValueModel(
        name: period.duration, value: period.id))
    .toList();

List<DropDownValueModel> dropDownListRooms = cubit.rooms
    .map((room) =>
    DropDownValueModel(
        name: room.name, value: room.id))
    .toList();


class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  final periodController =SingleValueDropDownController();
  final roomController =SingleValueDropDownController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ConstantVar.backgroundPage,
          centerTitle: true,
          title: GradientText(
            'Delete',
            style: GoogleFonts.eagleLake(fontSize: 20.sp),
            gradientType: GradientType.linear,
            colors: ConstantVar.gradientList,
          ),
        ),
        body: Container(
            margin: EdgeInsets.all(20.sp),
            padding: EdgeInsets.all(10.sp),
            child: Column(
              children: [
                DropDownTextField(
                  controller: periodController,
                  enableSearch: true,
                  searchDecoration:InputDecoration(
                    labelText: "Search Here",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xFF3E2723), width: 5.sp)),
                    labelStyle: const TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.bold),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xFF3E2723), width: 5.sp),
                    ),
                  ),
                  textFieldDecoration: InputDecoration(
                    labelText: "Period",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xFF3E2723), width: 5.sp)),
                    labelStyle: const TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.bold),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xFF3E2723), width: 5.sp),
                    ),
                    prefixIcon: const Icon(Icons.access_time_filled,
                        color: Colors.brown),
                  ),
                  listTextStyle: TextStyle(fontSize: 20.sp),
                  textStyle: TextStyle(fontSize: 20.sp),
                  dropDownItemCount: cubit.periods.length,
                  dropDownList:dropDownListPeriods,
                  onChanged: (value) {},
                ),
                SizedBox(height: 20.sp),
                DropDownTextField(
                  controller: roomController,
                  enableSearch: true,
                  searchDecoration:InputDecoration(
                    labelText: "Search Here",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xFF3E2723), width: 5.sp)),
                    labelStyle: const TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.bold),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xFF3E2723), width: 5.sp),
                    ),
                  ),
                  textFieldDecoration: InputDecoration(
                    labelText: "Room",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xFF3E2723), width: 5.sp)),
                    labelStyle: const TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.bold),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xFF3E2723), width: 5.sp),
                    ),
                    prefixIcon: const Icon(Icons.room,
                        color: Colors.brown),
                  ),
                  listTextStyle: TextStyle(fontSize: 20.sp),
                  textStyle: TextStyle(fontSize: 20.sp),
                  dropDownItemCount: cubit.rooms.length,
                  dropDownList:dropDownListRooms,
                  onChanged: (value) {

                  },
                ),
                SizedBox(height: 5.sp),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if(periodController.dropDownValue != null
                          && periodController.dropDownValue!.name.isNotEmpty) {
                        String selectedValue = periodController.dropDownValue!
                            .name;
                        print(selectedValue);
                        cubit.deletePeriod(selectedValue);
                      }
                      else if(roomController.dropDownValue != null
                          && roomController.dropDownValue!.name.isNotEmpty) {
                        String selectedValue = roomController.dropDownValue!
                            .name;
                        print(selectedValue);
                        cubit.deletePeriod(selectedValue);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.0.sp, vertical: 5.0.sp),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0.sp)),
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
                    ),
                  ),
                ),
                SizedBox(height: 5.sp),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.0.sp, vertical: 5.0.sp),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0.sp)),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}