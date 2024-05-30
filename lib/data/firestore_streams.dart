// firestore_streams.dart
import 'package:cloud_firestore/cloud_firestore.dart';

List<Stream<QuerySnapshot>> mergeFirestoreCollections() {
  var stream1 = FirebaseFirestore.instance
      .collection('cars')
      .doc('BMW')
      .collection('m-series')
      .snapshots();
  var stream2 = FirebaseFirestore.instance
      .collection('cars')
      .doc('BMW')
      .collection('x-series')
      .snapshots();
  var stream3 = FirebaseFirestore.instance
      .collection('cars')
      .doc('BMW')
      .collection('i-series')
      .snapshots();
  var stream4 = FirebaseFirestore.instance
      .collection('cars')
      .doc('Ferrari')
      .collection('IconaSeries')
      .snapshots();
  var stream5 = FirebaseFirestore.instance
      .collection('cars')
      .doc('Ferrari')
      .collection('RangeSeries')
      .snapshots();
  var stream6 = FirebaseFirestore.instance
      .collection('cars')
      .doc('Ferrari')
      .collection('SpecialSeries')
      .snapshots();

  return [stream1, stream2, stream3, stream4, stream5, stream6];
}
