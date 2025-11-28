// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:smart_umrah_app/Models/TravelAgentProfileData/travelAgent_profile_model.dart';
// import 'package:smart_umrah_app/Services/firebaseServices/firebaseDatabase/AgentData/agent_data.dart';
// import 'package:smart_umrah_app/Services/firebaseServices/firebaseDatabase/UserProfileData/FetchingProfile/fetch_profile.dart';
// import 'package:smart_umrah_app/routes/routes.dart';
// import 'package:smart_umrah_app/screens/User/chatScreen.dart';
// import 'package:smart_umrah_app/widgets/customButton.dart';

// class ViewTravelAgent extends StatelessWidget {
//   const ViewTravelAgent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AgentProfileDataCollection agentCollection =
//         AgentProfileDataCollection();

//     return Scaffold(
//       backgroundColor: const Color(0xFF1E2A38),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1E2A38),
//         elevation: 0,
//         title: const Text(
//           "Travel Agents",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,

//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () {
//               // Force rebuild to refresh data
//               (context as Element).reassemble();
//             },
//           ),

//           IconButton(
//             onPressed: () {
//               Get.toNamed(AppRoutes.allChats);
//             },
//             icon: Icon(Icons.message_rounded, color: Colors.white),
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("TravelAgents")
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No Travel Agents Found",
//                 style: TextStyle(color: Colors.white70, fontSize: 18),
//               ),
//             );
//           }

//           final List<TravelAgentProfileModel> agents = snapshot.data!.docs
//               .map(
//                 (doc) => TravelAgentProfileModel.fromFirebase(
//                   doc.data() as Map<String, dynamic>,
//                 ),
//               )
//               .toList();

//           return ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: agents.length,
//             itemBuilder: (context, index) {
//               final agent = agents[index];
//               return Card(
//                 color: const Color(0xFF283645),
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       // Agent image
//                       CircleAvatar(
//                         radius: 30,

//                         backgroundImage: agent.profileImageUrl != null
//                             ? NetworkImage(agent.profileImageUrl!)
//                             : const AssetImage(
//                                     'assets/images/agent_placeholder.png',
//                                   )
//                                   as ImageProvider,
//                       ),
//                       const SizedBox(width: 16),
//                       // Agent details
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               agent.name ?? "Unknown",
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               agent.email ?? "No email",
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               agent.permanentAddress ?? "No location",
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 13,
//                               ),
//                             ),

//                             const SizedBox(height: 8),
//                             Text(
//                               agent.isVerified == true
//                                   ? "Verified Agent"
//                                   : "Unverified Agent",
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 13,
//                               ),
//                             ),

//                             const SizedBox(height: 8),
//                             Text(
//                               agent.agencyName ?? "No Agency Name",
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 13,
//                               ),
//                             ),

//                             CustomButton(
//                               text: 'Send Request',
//                               onPressed: () {
//                                 sendRequestToAgent(
//                                   agent.id ?? "",
//                                   agent.name ?? "Agent",
//                                 );
//                               },
//                               height: 40,
//                               width: 150,
//                               backgroundColor: const Color.fromARGB(
//                                 255,
//                                 24,
//                                 25,
//                                 26,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Chat button
//                       // ElevatedButton.icon(
//                       //   onPressed: () {
//                       //     Get.to(
//                       //       () => ChatScreen(
//                       //         partnerId: agent.id ?? "",
//                       //         partnerName: agent.name ?? "Agent",
//                       //         partnerImageUrl: agent.profileImageUrl,
//                       //       ),
//                       //     );
//                       //   },

//                       //   style: ElevatedButton.styleFrom(
//                       //     backgroundColor: const Color(0xFF3B82F6),
//                       //     shape: RoundedRectangleBorder(
//                       //       borderRadius: BorderRadius.circular(12),
//                       //     ),
//                       //     padding: const EdgeInsets.symmetric(
//                       //       horizontal: 12,
//                       //       vertical: 10,
//                       //     ),
//                       //   ),
//                       //   icon: const Icon(Icons.chat, size: 20),
//                       //   label: const Text(
//                       //     "",
//                       //     style: TextStyle(fontWeight: FontWeight.bold),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Future<void> sendRequestToAgent(String agentId, String agentName) async {
//     final user = FirebaseAuth.instance.currentUser;

//     final currentUser = await fetchProfile();

//     if (user == null) {
//       Get.snackbar(
//         "Error",
//         "You must be logged in to send request",
//         backgroundColor: Colors.redAccent,
//       );
//       return;
//     }

//     final requestRef = FirebaseFirestore.instance.collection("Requests");

//     // Check if already requested
//     final alreadyRequested = await requestRef
//         .where("pilgrimId", isEqualTo: user.uid)
//         .where("agentId", isEqualTo: agentId)
//         .get();

//     if (alreadyRequested.docs.isNotEmpty) {
//       Get.snackbar(
//         "Already Sent",
//         "You have already sent a request to this agent.",
//         backgroundColor: Colors.orangeAccent,
//       );
//       return;
//     }

//     await requestRef.add({
//       "pilgrimId": user.uid,
//       "pilgrimEmail": user.email,
//       "pilgrimName": user.displayName ?? currentUser!.name ?? "Pilgrim",

//       "agentId": agentId,
//       "agentName": agentName,

//       "status": "pending",
//       "timestamp": FieldValue.serverTimestamp(),
//     });

//     Get.snackbar(
//       "Request Sent",
//       "Your request has been sent to the travel agent.",
//       backgroundColor: Colors.green,
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smart_umrah_app/Models/TravelAgentProfileData/travelAgent_profile_model.dart';
import 'package:smart_umrah_app/screens/User/chatScreen.dart';

class ViewTravelAgent extends StatelessWidget {
  const ViewTravelAgent({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF1E2A38),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2A38),
        title: const Text(
          "Travel Agents",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Requests")
            .where("pilgrimId", isEqualTo: userId)
            .snapshots(),
        builder: (context, requestSnap) {
          if (!requestSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reqDocs = requestSnap.data!.docs;

          // ------------------------------------------------------------
          // ✔ Check if an approved agent exists
          // ------------------------------------------------------------
          final approvedReq = reqDocs.cast<QueryDocumentSnapshot?>().firstWhere(
            (d) => d?["status"] == "approved",
            orElse: () => null,
          );

          if (approvedReq != null) {
            // ------------------------------------------------------------
            // ⭐  VIEW B: Only show approved agent + group chat
            // ------------------------------------------------------------
            final agentId = approvedReq["agentId"];
            return _approvedAgentView(agentId, userId);
          }

          // ------------------------------------------------------------
          // ⭐  VIEW A: Show ALL agents + request system
          // ------------------------------------------------------------
          return _allAgentsView(reqDocs, userId);
        },
      ),
    );
  }

  // ------------------------------------------------------------------
  // ⭐ VIEW A → Show ALL agents until request approved
  // ------------------------------------------------------------------
  Widget _allAgentsView(List<QueryDocumentSnapshot> reqDocs, String userId) {
    final pendingReq = reqDocs.cast<QueryDocumentSnapshot?>().firstWhere(
      (d) => d?["status"] == "pending",
      orElse: () => null,
    );

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("TravelAgents").snapshots(),
      builder: (context, agentSnap) {
        if (!agentSnap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: agentSnap.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final agent = TravelAgentProfileModel.fromFirebase(data);
            final agentId = doc.id;

            bool requestSent = false;

            for (var r in reqDocs) {
              if (r["agentId"] == agentId) {
                requestSent = true;
              }
            }

            return Card(
              color: const Color(0xFF283645),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: agent.profileImageUrl != null
                              ? NetworkImage(agent.profileImageUrl!)
                              : const AssetImage(
                                      'assets/images/agent_placeholder.png',
                                    )
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            agent.name ?? "Unknown Agent",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      agent.email ?? "No Email",
                      style: const TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      agent.agencyName ?? "No Agency",
                      style: const TextStyle(color: Colors.white60),
                    ),

                    const SizedBox(height: 14),

                    // --------------------------------------------------
                    // ✔ Send Request Button (disabled when pending)
                    // --------------------------------------------------
                    ElevatedButton(
                      onPressed: pendingReq != null || requestSent
                          ? null
                          : () => sendRequest(agentId, agent.name ?? ""),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: requestSent
                            ? Colors.grey
                            : Colors.teal,
                      ),
                      child: Text(
                        requestSent
                            ? "Request Sent"
                            : pendingReq != null
                            ? "Pending..."
                            : "Send Request",
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ------------------------------------------------------------------
  // ⭐ VIEW B → Show ONLY approved agent + group chat button
  // ------------------------------------------------------------------
  Widget _approvedAgentView(String agentId, String userId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("TravelAgents")
          .doc(agentId)
          .snapshots(),
      builder: (context, agentSnap) {
        if (!agentSnap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = agentSnap.data!.data() as Map<String, dynamic>;
        final agent = TravelAgentProfileModel.fromFirebase(data);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: const Color(0xFF283645),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: agent.profileImageUrl != null
                          ? NetworkImage(agent.profileImageUrl!)
                          : const AssetImage(
                                  'assets/images/agent_placeholder.png',
                                )
                                as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        agent.name ?? "Unknown Agent",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.group,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () =>
                          openGroupChat(agentId, agent.name ?? "Group"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------------
  // ⭐ Send Request to Agent
  // ------------------------------------------------------------------
  Future<void> sendRequest(String agentId, String agentName) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("Requests").add({
      "agentId": agentId,
      "pilgrimId": userId,
      "pilgrimName": FirebaseAuth.instance.currentUser!.displayName ?? "",
      "pilgrimEmail": FirebaseAuth.instance.currentUser!.email ?? "",
      "timestamp": FieldValue.serverTimestamp(),
      "status": "pending",
    });

    Get.snackbar(
      "Request Sent",
      "Your request was sent to $agentName",
      backgroundColor: Colors.green,
    );
  }

  // ------------------------------------------------------------------
  // ⭐ Open Group Chat (Pilgrim joins automatically after approval)
  // ------------------------------------------------------------------
  Future<void> openGroupChat(String agentId, String agentName) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final groupQuery = await FirebaseFirestore.instance
        .collection("chats")
        .where("agentGroup", isEqualTo: agentId)
        .limit(1)
        .get();

    DocumentReference chatRef;

    if (groupQuery.docs.isNotEmpty) {
      chatRef = groupQuery.docs.first.reference;

      await chatRef.update({
        "participants": FieldValue.arrayUnion([userId]),
      });
    } else {
      chatRef = FirebaseFirestore.instance.collection("chats").doc();

      await chatRef.set({
        "participants": [agentId, userId],
        "groupName": "$agentName Group",
        "agentGroup": agentId,
        "isGroup": true,
        "lastMessage": "",
        "lastTimestamp": FieldValue.serverTimestamp(),
      });
    }

    // Navigate
    Get.to(
      () => ChatScreen(partnerId: chatRef.id, partnerName: "$agentName Group"),
    );
  }
}
