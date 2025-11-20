import 'package:flutter/material.dart';
import 'package:smart_umrah_app/routes/routes.dart';

List<Map<String, dynamic>> get agentFeatures => [
  {
    'title': 'Register Profile',
    'icon': Icons.person_add,
    'description': 'Create new agent profile',
    'route': '/agent/register-profile',
  },
  {
    'title': 'Manage Profile',
    'icon': Icons.person,
    'description': 'Edit agent details',
    'route': '/agent/manage-profile',
  },
  {
    'title': 'Generate Schedule',
    'icon': Icons.calendar_month,
    'description': 'Create Umrah itineraries',
    'route': '/agent/generate-schedule',
  },
  {
    'title': 'Notifications',
    'icon': Icons.notifications,
    'description': 'View & send alerts',
    'route': '/agent/notifications',
  },
  {
    'title': 'In-app Messaging',
    'icon': Icons.message,
    'description': 'Communicate with pilgrims',
    'route': AppRoutes.allChats,
  },
  {
    'title': 'Book Hotel & Transport',
    'icon': Icons.hotel,
    'description': 'Arrange accommodations & travel',
    'route': '/agent/book-services',
  },
];
