import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../shared/presentation/widget/show_card.dart';

class OnGoingScreen extends StatelessWidget {
  final String staffId;
  const OnGoingScreen({Key? key, required this.staffId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ShowCard(staffId: staffId, status: 'Ongoing'),
    );
  }
}
