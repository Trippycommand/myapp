  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/material.dart';
  import 'package:myapp/UI%20component/Homepage/AddTransactionbutton.dart';
  import 'package:myapp/UI%20component/Homepage/appbar.dart';

  class HomePageUI extends StatelessWidget {
    final String fixedUID = 'qkIThgX4FqafhY5aeRIA';

    HomePageUI({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xffF7FCFA),
        appBar: const HomePageAppBar(),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future:
              FirebaseFirestore.instance.collection('User').doc(fixedUID).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("No data found for this user."));
            }

            final data = snapshot.data!.data();
            // Extract numeric total income
            final totatIncome = data?['totatIncome'];

            return Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 20,
                    ), // add some padding from edges
                    child: Text(
                      totatIncome != null ? '₹$totatIncome' : '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        //
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20,top: 4),
                    child: Text(
                      "Current Balance",
                      style: TextStyle(
                        color: Color(0xff479E7D),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Addtransactionbutton(),
                )
              ],
            );
          },
        ),
      );
    }
  }
