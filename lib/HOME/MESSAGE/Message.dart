import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  late CollectionReference messagesCollection;
  late CollectionReference usersCollection;
  final ScrollController _scrollController = ScrollController();
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    // Replace 'jobs posted' with your Firestore path
    messagesCollection = FirebaseFirestore.instance.collection('messages');
    usersCollection = FirebaseFirestore.instance.collection('users');

    searchController.addListener(_performSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Adjust the height as needed
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Column(
            children: [
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recrutio',
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 24, // Adjust the font size as needed
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3), // Grey color for the search bar
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesCollection.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                List<QueryDocumentSnapshot> messages = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> messageData =
                    messages[index].data() as Map<String, dynamic>;
                    String messageText = messageData['message'];
                    String sender = messageData['sender'];
                    Timestamp? timestamp = messageData['timestamp'];

                    String formattedTime = 'Timestamp not available';

                    if (timestamp != null) {
                      DateTime dateTime = timestamp.toDate();
                      formattedTime = DateFormat('HH:mm:ss dd-MM-yy').format(dateTime);
                    }

                    bool isCurrentUser = sender == 'Applicant' || sender == 'Recruiter';

                    return ListTile(
                      title: Row(
                        mainAxisAlignment:
                        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          Text(
                            messageText,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isCurrentUser
                                  ? const Color.fromARGB(255, 49, 134, 203)
                                  : const Color.fromARGB(255, 199, 210, 40),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment:
                        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isCurrentUser) const SizedBox(width: 8),
                          Text(
                            sender,
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!isCurrentUser) const SizedBox(width: 8),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              fontSize: 8,
                              color: Color.fromARGB(255, 4, 146, 51),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: isCurrentUser ? const EdgeInsets.only(left: 80.0, right: 8.0) : const EdgeInsets.only(left: 8.0, right: 80.0),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      hintText: 'Type your message here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 177, 217, 225),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    sendMessage(messageController.text);
                    messageController.clear();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void sendMessage(String messageText) {
    messagesCollection.add({
      'message': messageText,
      'sender': 'Applicant', // or 'Recruiter' depending on the user
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _performSearch() async {
    final query = searchController.text;
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
    } else {
      final snapshot = await usersCollection.where('name', isEqualTo: query).get();
      if (snapshot.docs.isNotEmpty) {
        final userNames = snapshot.docs.map((doc) => doc['name'] as String).toList();
        setState(() {
          searchResults = userNames;
        });
      } else {
        setState(() {
          searchResults.clear();
        });
      }
    }
  }
}
