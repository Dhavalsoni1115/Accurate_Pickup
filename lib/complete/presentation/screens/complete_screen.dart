import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../shared/presentation/widget/show_card.dart';

class CompleteScreen extends StatelessWidget {
  final String staffId;
  const CompleteScreen({Key? key, required this.staffId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ShowCard(staffId: staffId, status: 'Completed'),
    );
  }
}
