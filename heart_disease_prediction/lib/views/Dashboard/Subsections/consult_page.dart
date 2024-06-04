import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heart_disease_prediction/views/Dashboard/Subsections/Widgets/appointment.dart';
import 'package:heart_disease_prediction/views/Dashboard/Subsections/subsection.dart';

class ConsultPage extends StatefulWidget {
  final Uri uri;
  const ConsultPage({super.key, required this.uri});

  @override
  State<ConsultPage> createState() => _ConsultPageState();
}

class _ConsultPageState extends State<ConsultPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<Map<String, dynamic>>? doctorList;

  fetchData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection("Doctor").get();
    final docs = snapshot.docs;
    doctorList = [];
    for (final doc in docs) {
      doctorList!.add(doc.data());
    }

    setState(() {});
  }

  Widget emptyState() {
    return const Center(
      child: Text("No Doctor available.",
          style: TextStyle(color: Colors.white, fontSize: 16)),
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
        title: const Text("Consult", style: TextStyle(color: Colors.white)),
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
      body: doctorList == null
          ? const Center(
              child: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 3),
            ))
          : doctorList!.isEmpty
              ? emptyState()
              : GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 15),
                  itemCount: doctorList?.length,
                  itemBuilder: (context, index) {
                    final data = doctorList![index];
                    return Material(
                      color: const Color(0XFF262730),
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0XFF262730),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  content: AppointmentDialog(data: data)));
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(data['imageUrl']),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                data['name'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data['specialist'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ]),
                      ),
                    );
                  }),
    );
  }
}
