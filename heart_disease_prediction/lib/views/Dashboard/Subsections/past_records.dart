import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heart_disease_prediction/views/Dashboard/Subsections/subsection.dart';
import 'package:intl/intl.dart';

class PastRecords extends StatefulWidget {
  final Uri uri;
  const PastRecords({super.key, required this.uri});

  @override
  State<PastRecords> createState() => _PastRecordsState();
}

class _PastRecordsState extends State<PastRecords> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<Map<String, dynamic>>? recordList;

  fetchData() async {
    final data = await FirebaseFirestore.instance
        .collection("Dataset")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    final docs = data.docs;
    recordList = [];
    for (final doc in docs) {
      recordList?.add(doc.data());
    }

    recordList?.sort((a, b) => b['time'].compareTo(a['time']));

    setState(() {});
  }

  Widget emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("No Past Records.",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          TextButton(
            onPressed: () {
              context.goNamed('predict');
            },
            child: const Text(
              'Click to predict',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0XFF0E1117),
        drawer: screenWidth < 1024
            ? Subsection(width: screenWidth * 0.3, uri: widget.uri)
            : null,
        appBar: AppBar(
          backgroundColor: const Color(0XFF0E1117),
          title:
              const Text("Past Records", style: TextStyle(color: Colors.white)),
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: screenWidth < 1024
              ? IconButton(
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                  icon: const Icon(Icons.menu, color: Colors.white))
              : null,
        ),
        body: recordList == null
            ? const Center(
                child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 3),
              ))
            : recordList!.isEmpty
                ? emptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    itemCount: recordList!.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final data = recordList![index];
                      DateTime time = data['time'].toDate() as DateTime;
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0XFF262730),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color(0XFF0E1117),
                            ),
                            title: SelectableText(
                              "Record Id : ${data['docId']}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: "Prediction: ",
                                        style: const TextStyle(
                                            color: Colors.white54),
                                        children: [
                                      TextSpan(
                                          text: data['target'] == 1
                                              ? "True"
                                              : "False",
                                          style: TextStyle(
                                              color: data['target'] == 1
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                              ", ${DateFormat("d MMM yyyy hh:mm a").format(time)}",
                                          style: const TextStyle(
                                              color: Colors.white54,
                                              fontWeight: FontWeight.normal)),
                                    ])),
                                if (data['doctorId'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: AppointedDoctor(
                                      doctorId: data['doctorId'],
                                      appointmentDate:
                                          data['appointmentDate'].toDate(),
                                    ),
                                  )
                              ],
                            ),
                            onTap: () {},
                            trailing: data['target'] == 1
                                ? data['doctorId'] != null
                                    ? const SizedBox()
                                    : ElevatedButton(
                                        onPressed: () {
                                          context.goNamed("consult");
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0XFFfe5e3d)),
                                        child: const Text(
                                          "Consult",
                                          style: TextStyle(color: Colors.white),
                                        ))
                                : null),
                      );
                    }));
  }
}

class AppointedDoctor extends StatelessWidget {
  final String doctorId;
  final DateTime appointmentDate;
  const AppointedDoctor(
      {super.key, required this.doctorId, required this.appointmentDate});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('Doctor').doc(doctorId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(
              "Loading...",
              style: TextStyle(color: Colors.white30),
            );
          }

          final data = snapshot.data!.data();
          return RichText(
              text: TextSpan(
                  text: "Appointment: ",
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                  children: [
                TextSpan(
                    text:
                        "${data!['name']} on ${DateFormat("d MMM yyyy").format(appointmentDate)}",
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
              ]));
        });
  }
}
