// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:workout_tracker_app/components/exercise_tile.dart';
import 'package:workout_tracker_app/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onCeckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false).checkOffExercise(workoutName, exerciseName);
  }

  //text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add a new exercise"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //exercise name
            ExerciseTextField(controller: exerciseNameController, textFieldName: "Exercise Name"),
            //weight
            ExerciseTextField(controller: weightController, textFieldName: "Weight"),

            //reps
            ExerciseTextField(controller: repsController, textFieldName: "Reps"),

            //sets
            ExerciseTextField(controller: setsController, textFieldName: "Sets"),
          ],
        ),
        actions: [
          //save button*
          MaterialButton(
            color: Colors.amber,
            onPressed: save,
            child: Text("Save"),
          ),
          //cancel button
          MaterialButton(
            color: Colors.grey,
            onPressed: cancel,
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void save() {
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
    );
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.workoutName),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: Icon(Icons.add),
        ),
        body: Container(
          color: Colors.grey[300],
          child: ListView.builder(
            itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: ExerciseTile(
                exerciseName: value.getRelevantWorkout(widget.workoutName).exercises[index].name,
                weight: value.getRelevantWorkout(widget.workoutName).exercises[index].weight,
                reps: value.getRelevantWorkout(widget.workoutName).exercises[index].reps,
                sets: value.getRelevantWorkout(widget.workoutName).exercises[index].sets,
                isCompleted: value.getRelevantWorkout(widget.workoutName).exercises[index].isCompleted,
                onCheckBoxChanged: (val) {
                  onCeckBoxChanged(
                      widget.workoutName, value.getRelevantWorkout(widget.workoutName).exercises[index].name);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseTextField extends StatelessWidget {
  const ExerciseTextField({
    Key? key,
    required this.controller,
    required this.textFieldName,
  }) : super(key: key);

  final TextEditingController controller;
  final String textFieldName;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(hintText: textFieldName, hintStyle: TextStyle(color: Colors.grey)),
      controller: controller,
    );
  }
}
