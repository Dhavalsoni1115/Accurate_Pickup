import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

import '../screens/appoitment_detail_screen.dart';
import 'card_detail.dart';

class ShowCard extends StatefulWidget {
  final String status, staffId;
  const ShowCard({Key? key, required this.staffId, required this.status})
      : super(key: key);

  @override
  State<ShowCard> createState() => _ShowCardState();
}

class _ShowCardState extends State<ShowCard> {
  @override
  Widget build(BuildContext context) {
    var appoitmentData = FirebaseFirestore.instance
        .collection("appointments")
        .where('staffId', isEqualTo: widget.staffId);
    appoitmentData = appoitmentData.where('status', isEqualTo: widget.status);

    print(appoitmentData);

    return StreamBuilder(
      stream: appoitmentData.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: primaryColor,
          ));
        }
        if (snapshot.hasData) {
          // snapshot.data!.docs.sort((a, b) {
          //   var adata = a['date'];
          //   var bdata = b['date'];
          //   return adata.toString().compareTo(bdata.toString());
          // });
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          documents.sort((a, b) {
            var adata = DateFormat('dd-MMM-yyyy')
                .format(DateTime.parse(a['date'].toString()));
            var bdata = DateFormat('dd-MMM-yyyy')
                .format(DateTime.parse(b['date'].toString()));
            print('zhjcvbzhjxvczhjvxchvzxch=============');
            print(adata);
            print(bdata);
            //final DateFormat formatter = DateFormat('dd-MMM-yyyy');
            return bdata.toString().compareTo(adata.toString());
          });
          // documents = [...documents];
          return documents.isNotEmpty
              ? ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = documents[index];
                    print(doc);
                    final DateTime now = DateTime.parse(doc['date'].toString());
                    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
                    final String formatted = formatter.format(now);

                    return CardDetail(
                      name: doc['name'],
                      email: doc['email'],
                      mobileNumber: doc['mobile'].toString(),
                      date: formatted.toString(),
                      time: doc['time'],
                      onTap: () {
                        if (doc.id.isEmpty) {
                          return;
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppoitmentDetailScreen(
                                appoitmentId: doc['id'].toString(),
                              ),
                            ),
                          );
                        }
                      },
                    );
                    // : SizedBox();
                  },
                )
              : Center(
                  child: Text('No Appointment'),
                );
        } else {
          return Column(
            children: [
              Expanded(
                child: Container(
                  color: backgroundColor,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
