import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final List<Map<String, String>> books = [
    {
      "title": "You are not so smart",
      "author": "David McRaney",
      "image": "assets/images/notsmart.jpg"
    },
    {
      "title": "Atomic Habits",
      "author": "James Clear",
      "image": "assets/images/atomic.jpg"
    },
    {
      "title": "Rich Dad Poor Dad",
      "author": "Robert Kiyosaki",
      "image": "assets/images/richpoor.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Books"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

          return GestureDetector(
            onTap: () {
              // TODO: open pdf later
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(bottom: 16),

              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Book image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        book["image"]!,
                        height: 80,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Title and author
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book["title"]!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "by ${book["author"]!}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}