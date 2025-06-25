import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDatabase {
  Future<void> addEvent(Map<String, dynamic> eventData, String id) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .doc(id)
        .set(eventData);
  }

  Future<List<String>> getDepartments() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Departments").get();

    List<String> departments =
        snapshot.docs
            .map((doc) => doc['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();

    return departments;
  }

  Future<void> addDepartment(String name) async {
    await FirebaseFirestore.instance.collection("Departments").add({
      "name": name,
    });
  }

  Future<void> deleteDepartmentByName(String name) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection("Departments")
            .where("name", isEqualTo: name)
            .get();

    for (var doc in snapshot.docs) {
      await FirebaseFirestore.instance
          .collection("Departments")
          .doc(doc.id)
          .delete();
    }
  }
}
