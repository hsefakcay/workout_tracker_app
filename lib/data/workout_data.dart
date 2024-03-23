import 'package:flutter/material.dart';
import 'package:workout_tracker_app/data/hive_database.dart';
import 'package:workout_tracker_app/datetime/date_time.dart';
import 'package:workout_tracker_app/models/exercise.dart';
import 'package:workout_tracker_app/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();
  /*
    WORKOUT DATA STRUCTURE
    
  */

  List<Workout> workoutList = [
    //default workout
    Workout(name: "Upper Body", exercises: [
      Exercise(
        name: "Biceps Curls",
        weight: "10",
        reps: "12",
        sets: "3",
      ),
      Exercise(
        name: "Triceps",
        weight: "20",
        reps: "12",
        sets: "3",
      ),
    ]),

    Workout(name: "Lower Body", exercises: [
      Exercise(
        name: " Squats",
        weight: "50",
        reps: "12",
        sets: "3",
      )
    ]),
  ];

  //if there are workouts already in database, then get that workout list,
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    }
    //otherwise use default workouts
    else {
      db.saveToDatabase(workoutList);
    }

    // load heat map
    loadHeatMap();
  }

  //get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get length of a given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  //ad a workout
  void addWorkout(String name) {
    //add a new workout with a blank list of exercise
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();

    //save to database
    db.saveToDatabase(workoutList);
  }

  //add an exercise to workout
  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets) {
    //find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(Exercise(
      name: exerciseName,
      weight: weight,
      reps: reps,
      sets: sets,
    ));

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //find relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    //check off boolean to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);

    loadHeatMap();
  }

  //get length of a given workout

  //return relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout = workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  //return relevant exercise object, given a workout name + exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    Exercise relevantExercise = relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }

  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

  /*


      HEAT MAP

  */
  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    //count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //go from start date to today, and add each completiton status to the db
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      int completionStatus = db.getCompletionStatus(yyyymmdd);

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{DateTime(year, month, day): completionStatus};

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
