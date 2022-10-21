import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivers_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = "AIzaSyDkUpn2b725CEuDxZYhfPNx9wOxYogDcMM";

User firebaseUser;

Users userCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;