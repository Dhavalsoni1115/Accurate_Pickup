import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../shared/presentation/widget/show_card.dart';

class OpenScreen extends StatefulWidget {
  final String staffId;
  const OpenScreen({Key? key, required this.staffId}) : super(key: key);

  @override
  State<OpenScreen> createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ShowCard(
        staffId: widget.staffId,
        status: 'Open',
      ),
    );
  }
}
