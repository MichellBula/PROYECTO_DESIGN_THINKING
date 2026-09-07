import 'package:flutter/material.dart';

class EventData {
  final String day;
  final String time;
  final String title;
  final String project;
  final String tag;
  final IconData icon;
  final EventType type;

  const EventData({
    required this.day,
    required this.time,
    required this.title,
    required this.project,
    required this.tag,
    required this.icon,
    required this.type,
  });
}

enum EventType {
  task,
  meeting,
}