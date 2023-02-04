import 'package:flutter/material.dart';

// add firestore
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({
    super.key,
  });

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  // read data
  CollectionReference product =
      FirebaseFirestore.instance.collection('restaurants');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: product.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['class']),
                  ),
                );
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
