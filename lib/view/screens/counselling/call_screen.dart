import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import '../../../model/intern_model.dart';

class CallScreen extends StatelessWidget {
  final Intern intern;

  const 
  CallScreen({super.key, required this.intern});

  void startCall() {
    final jitsi = JitsiMeet();

    jitsi.join(
      JitsiMeetConferenceOptions(
        room: "supportHive_${intern.name}",
        userInfo: JitsiMeetUserInfo(
          displayName: "User",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    startCall();

    return const Scaffold(
      body: Center(child: Text("Connecting...")),
    );
  }
}