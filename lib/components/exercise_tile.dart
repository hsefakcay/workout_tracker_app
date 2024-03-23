import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile(
      {super.key,
      required this.exerciseName,
      required this.weight,
      required this.reps,
      required this.sets,
      required this.isCompleted,
      required this.onCheckBoxChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: ListTile(
        title: Text(
          exerciseName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Chip(label: Text("${weight} kg", overflow: TextOverflow.clip)),
            Chip(label: Text("${reps} reps ")),
            Chip(label: Text("${sets} sets")),
          ],
        ),
        trailing: Transform.scale(
          scale: 2,
          child: Checkbox(
            activeColor: Colors.green,
            value: isCompleted,
            onChanged: (value) => onCheckBoxChanged!(value),
          ),
        ),
      ),
    );
  }
}
