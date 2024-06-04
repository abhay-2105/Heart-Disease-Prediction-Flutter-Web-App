import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heart_disease_prediction/Services/app_service.dart';
import 'package:heart_disease_prediction/views/Dashboard/Subsections/subsection.dart';
import 'package:heart_disease_prediction/widgets/custom_input_feild.dart';
import 'package:http/http.dart' as http;

class Predict extends StatefulWidget {
  final Uri uri;
  const Predict({super.key, required this.uri});

  @override
  State<Predict> createState() => _PredictState();
}

class _PredictState extends State<Predict> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int? predict;
  String resultText = "Test Result will show here.";
  bool loading = false;
  TextEditingController age = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController chestPain = TextEditingController();
  TextEditingController restBP = TextEditingController();
  TextEditingController insulinLevel = TextEditingController();
  TextEditingController serum = TextEditingController();
  TextEditingController fastBP = TextEditingController();
  TextEditingController restECG = TextEditingController();
  TextEditingController maxHeartRate = TextEditingController();
  TextEditingController angina = TextEditingController();
  TextEditingController oldPeak = TextEditingController();
  TextEditingController slope = TextEditingController();
  TextEditingController vessel = TextEditingController();
  TextEditingController thal = TextEditingController();

  Future<dynamic> fetchAPi(List<double> data) async {
    final response = await http.post(Uri.http('192.168.68.85:4000', '/predict'),
        body: jsonEncode({"heart_data": data}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return jsonDecode(response.body);
    } else {
      debugPrint(response.reasonPhrase);
    }
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
        title: const Text("Predict", style: TextStyle(color: Colors.white)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
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
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: MediaQuery.of(context).size.width * 0.015,
                      runSpacing: 15,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      alignment: WrapAlignment.start,
                      children: [
                        CustomInputFeild(title: "Age", controller: age),
                        CustomInputFeild(title: "Sex", controller: sex),
                        CustomInputFeild(
                            title: "Chest pain type", controller: chestPain),
                        CustomInputFeild(
                            title: "Resting blood pressure",
                            controller: restBP),
                        CustomInputFeild(
                            title: "Serum cholestoral in mg/dl",
                            controller: serum),
                        CustomInputFeild(
                            title: "Fasting blood sugar > 120 mg/dl",
                            controller: fastBP),
                        CustomInputFeild(
                            title:
                                "Resting electrocardiographic results (values 0,1,2)",
                            controller: restECG),
                        CustomInputFeild(
                            title: "Maximum heart rate achieved",
                            controller: maxHeartRate),
                        CustomInputFeild(
                            title: "Exercise induced angina",
                            controller: angina),
                        CustomInputFeild(
                            title:
                                "oldpeak = ST depression induced by exercise relative to rest",
                            controller: oldPeak),
                        CustomInputFeild(
                            title: "Slope of the peak exercise ST segment",
                            controller: slope),
                        CustomInputFeild(
                            title:
                                "No. of major vessels (0-3) colored by flourosopy",
                            controller: vessel),
                        CustomInputFeild(
                            title:
                                "Thal 0 = normal; 1 = fixed defect; 2 = reversable defect",
                            controller: thal),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () async {
                              loading = true;
                              setState(() {});
                              // [43, 0, 0, 132, 341, 1, 0, 136, 1, 3, 1, 0, 3]
                              try {
                                List<double> data = [];
                                data.add(double.parse(age.text));
                                data.add(double.parse(sex.text));
                                data.add(double.parse(chestPain.text));
                                data.add(double.parse(restBP.text));
                                data.add(double.parse(serum.text));
                                data.add(double.parse(fastBP.text));
                                data.add(double.parse(restECG.text));
                                data.add(double.parse(maxHeartRate.text));
                                data.add(double.parse(angina.text));
                                data.add(double.parse(oldPeak.text));
                                data.add(double.parse(slope.text));
                                data.add(double.parse(vessel.text));
                                data.add(double.parse(thal.text));
                                try {
                                  final response = await fetchAPi(data);
                                  resultText = response['statement'];
                                  predict = response['predict'];
                                  await AppServices.sendDataToFirebase(
                                      data, predict!);
                                } catch (error) {
                                  if (!mounted) return;
                                  AppServices.openSnackbar(
                                      context, error.toString());
                                }
                              } catch (error) {
                                if (!mounted) return;
                                AppServices.openSnackbar(context,
                                    "Please fill all the fields properly.");
                              }
                              loading = false;
                              setState(() {});
                            },
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                        color: Color(0XFF262730))),
                                backgroundColor: const Color(0XFF0E1117)),
                            child: const Text(
                              "Predict Heart Disease",
                              style: TextStyle(color: Colors.white70),
                            )),
                        const SizedBox(width: 20),
                        if (loading)
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        if (!loading)
                          TextButton(
                              onPressed: () {
                                age.text = "";
                                sex.text = "";
                                chestPain.text = "";
                                restBP.text = "";
                                serum.text = "";
                                fastBP.text = "";
                                restECG.text = "";
                                maxHeartRate.text = "";
                                angina.text = "";
                                oldPeak.text = "";
                                slope.text = "";
                                vessel.text = "";
                                thal.text = "";
                              },
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                          color: Color(0XFF262730))),
                                  backgroundColor: const Color(0XFF0E1117)),
                              child: const Text(
                                "Reset Fields",
                                style: TextStyle(color: Colors.white70),
                              )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: const Color(0XFF262730),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Text(
                            resultText,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: predict == null
                                    ? Colors.white
                                    : predict == 1
                                        ? Colors.red
                                        : Colors.green),
                          ),
                          const Spacer(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
