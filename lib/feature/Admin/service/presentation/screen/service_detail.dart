// import 'dart:io';
//
// import 'package:app/core/widget/text_field.dart';
// import 'package:app/feature/Admin/service/presentation/widget/servent_detail.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
//
//
// class ServiceDetailScreen extends StatefulWidget {
//   final String serviceTitle;
//
//   const ServiceDetailScreen({required this.serviceTitle, Key? key})
//       : super(key: key);
//
//   @override
//   _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
// }
//
// class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
//   final List<Map<String, dynamic>> persons = [];
//   final picker = ImagePicker();
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // No Firebase, so no initial load
//   }
//
//
//   void _showServiceDialog() {
//     File? dialogPickedImage;
//
//     final nameCtrl = TextEditingController();
//     final roleCtrl = TextEditingController();
//     final numberCtrl = TextEditingController();
//     final idCtrl = TextEditingController();
//     String? experience;
//     String? country;
//
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: "Add Person",
//       transitionDuration: const Duration(milliseconds: 500),
//       pageBuilder: (context, animation, secondaryAnimation) {
//         return const SizedBox.shrink();
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         final curvedAnimation = CurvedAnimation(
//           parent: animation,
//           curve: Curves.easeOutBack,
//         );
//
//         return FadeTransition(
//           opacity: animation,
//           child: SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(0, 0.2), // slide up from bottom
//               end: Offset.zero,
//             ).animate(curvedAnimation),
//             child: ScaleTransition(
//               scale: curvedAnimation,
//               child: Center(
//                 child: Material(
//                   color: Colors.transparent,
//                   child: StatefulBuilder(
//                     builder: (context, setStateDialog) {
//                       return Container(
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black26.withOpacity(0.25),
//                               blurRadius: 20,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text(
//                                 "Add Person",
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.teal,
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               GestureDetector(
//                                 onTap: () async {
//                                   final XFile? image = await picker.pickImage(
//                                     source: ImageSource.gallery,
//                                   );
//                                   if (image != null) {
//                                     setStateDialog(() {
//                                       dialogPickedImage = File(image.path);
//                                     });
//                                   }
//                                 },
//                                 child: CircleAvatar(
//                                   radius: 55,
//                                   backgroundColor: Colors.teal.shade100,
//                                   backgroundImage: dialogPickedImage != null
//                                       ? FileImage(dialogPickedImage!)
//                                       : null,
//                                   child: dialogPickedImage == null
//                                       ? const Icon(Icons.camera_alt,
//                                       size: 32, color: Colors.white)
//                                       : null,
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               CustomTextField(
//                                 controller: nameCtrl,
//                                 label: "Name",
//                                 icon: Icons.person,
//                               ),
//                               const SizedBox(height: 12),
//                               CustomTextField(
//                                 controller: idCtrl,
//                                 label: "ID",
//                                 icon: Icons.badge,
//                               ),
//                               const SizedBox(height: 12),
//                               CustomTextField(
//                                 controller: roleCtrl,
//                                 label: "Work Type",
//                                 icon: Icons.work,
//                               ),
//                               const SizedBox(height: 12),
//                               CustomTextField(
//                                 controller: numberCtrl,
//                                 label: "Number",
//                                 icon: Icons.phone,
//                                 keyboardType: TextInputType.phone,
//                               ),
//                               const SizedBox(height: 12),
//                               CustomDropdown(
//                                 value: experience,
//                                 label: "Experience",
//                                 icon: Icons.timeline,
//                                 items: ["1 year", "2 years", "3 years", "5+ years"],
//                                 onChanged: (value) {
//                                   setStateDialog(() => experience = value);
//                                 },
//                               ),
//                               const SizedBox(height: 12),
//                               CustomDropdown(
//                                 value: country,
//                                 label: "Country",
//                                 icon: Icons.public,
//                                 items: ["Bangladesh", "India", "USA", "UK"],
//                                 onChanged: (value) {
//                                   setStateDialog(() => country = value);
//                                 },
//                               ),
//                               const SizedBox(height: 20),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   TextButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     child: const Text(
//                                       "Cancel",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ),
//                                   ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.teal,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 24, vertical: 12),
//                                       elevation: 5,
//                                     ),
//                                     onPressed: () {
//                                       if (nameCtrl.text.isNotEmpty &&
//                                           roleCtrl.text.isNotEmpty &&
//                                           numberCtrl.text.isNotEmpty &&
//                                           country != null &&
//                                           idCtrl.text.isNotEmpty) {
//                                         final personData = {
//                                           "name": nameCtrl.text,
//                                           "experience": experience,
//                                           "workType": roleCtrl.text,
//                                           "number": numberCtrl.text,
//                                           "country": country,
//                                           "imageFile": dialogPickedImage,
//                                           "id": idCtrl.text,
//                                         };
//
//                                         setState(() {
//                                           persons.add(personData);
//                                         });
//
//                                         Navigator.pop(context);
//                                       } else {
//                                         ScaffoldMessenger.of(context).showSnackBar(
//                                           const SnackBar(
//                                               content:
//                                               Text("Please fill all fields")),
//                                         );
//                                       }
//                                     },
//                                     child: const Text(
//                                       "Save",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//   void deletePerson(String id) {
//     setState(() {
//       persons.removeWhere((element) => element['id'] == id);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final total = persons.length;
//
//     return Scaffold(
//       backgroundColor: const Color(0xffF7FAFF),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: Text("${widget.serviceTitle} ($total)"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: persons.isEmpty
//             ? const Center(child: Text('No persons added yet.'))
//             : ListView.builder(
//                 itemCount: total,
//                 itemBuilder: (context, index) {
//                   final person = persons[index];
//                   final number = index + 1;
//                   return Card(
//                     color: Colors.white,
//                     child: ListTile(
//                       leading: person['imageFile'] != null
//                           ? CircleAvatar(
//                               backgroundImage: FileImage(person['imageFile']),
//                             )
//                           : const CircleAvatar(
//                               child: Icon(Icons.person),
//                             ),
//                       title: Text("$number. ${person['name'] ?? 'Unnamed'}"),
//                       subtitle: Text(
//                         "${person['workType'] ?? ''}, ${person['experience'] ?? ''}",
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () {
//                           deletePerson(person['id']);
//                         },
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 PersonDetailsPage(person: person),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor:  Colors.teal,
//         onPressed: _showServiceDialog,
//         child: const Icon(Icons.add,color: Colors.white),
//       ),
//     );
//   }
// }
//
// // Custom Dropdown Widget
// class CustomDropdown extends StatelessWidget {
//   final String? value;
//   final String label;
//   final IconData icon;
//   final List<String> items;
//   final Function(String?) onChanged;
//
//   const CustomDropdown({
//     required this.value,
//     required this.label,
//     required this.icon,
//     required this.items,
//     required this.onChanged,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//       items: items.map((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//       onChanged: onChanged,
//     );
//   }
// }
import 'dart:io';

import 'package:app/core/widget/text_field.dart';
import 'package:app/feature/Admin/service/presentation/widget/servent_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceTitle;

  const ServiceDetailScreen({required this.serviceTitle, Key? key})
      : super(key: key);

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final picker = ImagePicker();
  List<Map<String, dynamic>> persons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPersons();
  }

  Future<void> _fetchPersons() async {
    setState(() => isLoading = true);
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("admins")
          .doc(uid)
          .collection("services")
          .doc(widget.serviceTitle)
          .collection("persons")
          .orderBy("createdAt", descending: true)
          .snapshots()
          .listen((snapshot) {
        persons = snapshot.docs.map((doc) => doc.data()).toList();
        setState(() => isLoading = false);
      });
    }
  }

  void _showServiceDialog() {
    File? dialogPickedImage;

    final nameCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final numberCtrl = TextEditingController();
    final idCtrl = TextEditingController();
    String? experience;
    String? country;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Add Person",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) =>
      const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation =
        CurvedAnimation(parent: animation, curve: Curves.easeOutBack);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
                .animate(curvedAnimation),
            child: ScaleTransition(
              scale: curvedAnimation,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: StatefulBuilder(
                    builder: (context, setStateDialog) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Add Person",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () async {
                                  final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (image != null) {
                                    setStateDialog(() {
                                      dialogPickedImage = File(image.path);
                                    });
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.teal.shade100,
                                  backgroundImage: dialogPickedImage != null
                                      ? FileImage(dialogPickedImage!)
                                      : null,
                                  child: dialogPickedImage == null
                                      ? const Icon(Icons.camera_alt,
                                      size: 32, color: Colors.white)
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                  controller: nameCtrl,
                                  label: "Name",
                                  icon: Icons.person),
                              const SizedBox(height: 12),
                              CustomTextField(
                                  controller: idCtrl, label: "ID", icon: Icons.badge),
                              const SizedBox(height: 12),
                              CustomTextField(
                                  controller: roleCtrl,
                                  label: "Work Type",
                                  icon: Icons.work),
                              const SizedBox(height: 12),
                              CustomTextField(
                                  controller: numberCtrl,
                                  label: "Number",
                                  icon: Icons.phone,
                                  keyboardType: TextInputType.phone),
                              const SizedBox(height: 12),
                              CustomDropdown(
                                value: experience,
                                label: "Experience",
                                icon: Icons.timeline,
                                items: ["1 year", "2 years", "3 years", "5+ years"],
                                onChanged: (value) =>
                                    setStateDialog(() => experience = value),
                              ),
                              const SizedBox(height: 12),
                              CustomDropdown(
                                value: country,
                                label: "Country",
                                icon: Icons.public,
                                items: ["Bangladesh", "India", "USA", "UK"],
                                onChanged: (value) =>
                                    setStateDialog(() => country = value),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                      elevation: 5,
                                    ),
                                    onPressed: () async {
                                      if (nameCtrl.text.isNotEmpty &&
                                          roleCtrl.text.isNotEmpty &&
                                          numberCtrl.text.isNotEmpty &&
                                          country != null &&
                                          idCtrl.text.isNotEmpty) {
                                        String? imageUrl;

                                        // Upload image
                                        if (dialogPickedImage != null) {
                                          final storageRef = FirebaseStorage.instance
                                              .ref()
                                              .child(
                                              "serviceApp/persons/${DateTime.now().millisecondsSinceEpoch}.jpg");
                                          await storageRef.putFile(dialogPickedImage!);
                                          imageUrl = await storageRef.getDownloadURL();
                                        }

                                        final personData = {
                                          "name": nameCtrl.text,
                                          "experience": experience,
                                          "workType": roleCtrl.text,
                                          "number": numberCtrl.text,
                                          "country": country,
                                          "imageUrl": imageUrl,
                                          "id": idCtrl.text,
                                          "createdAt": FieldValue.serverTimestamp(),
                                        };

                                        // Save in Firestore
                                        String? uid =
                                            FirebaseAuth.instance.currentUser?.uid;
                                        if (uid != null) {
                                          await FirebaseFirestore.instance
                                              .collection("serviceApp")
                                              .doc("appData")
                                              .collection("admins")
                                              .doc(uid)
                                              .collection("services")
                                              .doc(widget.serviceTitle)
                                              .collection("persons")
                                              .doc(idCtrl.text)
                                              .set(personData);
                                        }

                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content:
                                            Text("Please fill all fields")));
                                      }
                                    },
                                    child: const Text("Save",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void deletePerson(String id) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection("serviceApp")
          .doc("appData")
          .collection("admins")
          .doc(uid)
          .collection("services")
          .doc(widget.serviceTitle)
          .collection("persons")
          .doc(id)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = persons.length;

    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("${widget.serviceTitle} ($total)"),
      ),
      body: isLoading
          ? _shimmerLoader()
          : RefreshIndicator(
        onRefresh: _fetchPersons,
        child: persons.isEmpty
            ? const Center(child: Text('No persons added yet.'))
            : ListView.builder(
          itemCount: persons.length,
          itemBuilder: (context, index) {
            final person = persons[index];
            final number = index + 1;
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: person['imageUrl'] != null
                    ? CircleAvatar(
                  backgroundImage:
                  NetworkImage(person['imageUrl']),
                )
                    : const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text("$number. ${person['name'] ?? 'Unnamed'}"),
                subtitle: Text(
                    "${person['workType'] ?? ''}, ${person['experience'] ?? ''}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    deletePerson(person['id']);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PersonDetailsPage(person: person),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _showServiceDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _shimmerLoader() {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Row(
            children: [
              Container(width: 50, height: 50, color: Colors.white, margin: const EdgeInsets.only(right: 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 12, color: Colors.white, margin: const EdgeInsets.only(bottom: 6)),
                    Container(height: 12, width: 150, color: Colors.white),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Dropdown Widget
class CustomDropdown extends StatelessWidget {
  final String? value;
  final String label;
  final IconData icon;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
