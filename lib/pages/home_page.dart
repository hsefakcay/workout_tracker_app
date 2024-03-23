import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker_app/components/heat_map.dart';
import 'package:workout_tracker_app/data/workout_data.dart';
import 'package:workout_tracker_app/pages/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  //text controller
  final newWorkoutNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[400],
          appBar: AppBar(
            title: Text("Workout Tracker"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewWorkout,
            child: Icon(Icons.add),
          ),
          body: ListView(
              //HEAT MAP
              children: [
                MyHeatMap(
                  datesets: value.heatMapDataSet,
                  startDateYYYYMMDD: value.getStartDate(),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getWorkoutList().length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: ListTile(
                      tileColor: Color.fromARGB(255, 3, 2, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.amber, width: 2),
                      ),
                      leading: const Icon(
                        Icons.fitness_center_sharp,
                        size: 32,
                        color: Colors.amber,
                      ),
                      title: Text(
                        value.getWorkoutList()[index].name.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.amber,
                        ),
                        onPressed: () => goToWorkoutPage(value.getWorkoutList()[index].name),
                      ),
                    ),
                  ),
                ),
              ]
              //Workout List

              )),
    );
  }

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create new workout"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          //save button*
          MaterialButton(
            onPressed: save,
            child: Text("Save"),
          ),
          //cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
