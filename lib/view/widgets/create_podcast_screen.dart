import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supporthive1/controller/home_controller.dart';
import 'package:supporthive1/model/podcast.dart';

class CreatePodcastScreen extends StatefulWidget {
  const CreatePodcastScreen({super.key});

  @override
  State<CreatePodcastScreen> createState() => _CreatePodcastScreenState();
}

class _CreatePodcastScreenState extends State<CreatePodcastScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedCategory;

  File? selectedFile;

  final List<String> categories = [
    "Mental Health",
    "Meditation",
    "Stress Relief",
    "Sleep",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mic, color: Color(0xFF4A6741)),
                  const SizedBox(width: 8),
                  const Text(
                    "Create New Podcast",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),

            // 🔹 Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Podcast Title *"),
                    _textField(titleController, "e.g., Mindful Moments"),

                    _label("Host Name *"),
                    _textField(authorController, "e.g., Dr. John Doe"),

                    _label("Duration *"),
                    _textField(durationController, "e.g., 25:30"),
                    const SizedBox(height: 4),
                    const Text(
                      "Format: MM:SS",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    _label("Category *"),
                    _dropdown(),

                    _label("Description"),
                    _textField(
                      descriptionController,
                      "Brief description of your podcast episode...",
                      maxLines: 4,
                    ),

                    _label("Podcast Audio File"),
                    _uploadBox(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // 🔹 Bottom Buttons
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      if(titleController.text.isEmpty||authorController.text.isEmpty||durationController.text.isEmpty||selectedCategory==null || selectedFile == null){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill the all required field")),
                        );
                        return;
                      }

                      final controller = HomeController();

                      final newPodcast = Podcast(
                        title: titleController.text, 
                        author: authorController.text, 
                        category: selectedCategory!, 
                        duration: durationController.text, 
                        audioUrl: selectedFile!.path,
                        isNew: true,
                        );

                        controller.addPodcast(newPodcast);

                        Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Create Podcast"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D7A2A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🔹 Label
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  // 🔹 TextField
  Widget _textField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // 🔹 Dropdown
  Widget _dropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      items: categories
          .map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },
      decoration: InputDecoration(
        hintText: "Select Category",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // 🔹 Upload Box UI
  Widget _uploadBox() {
  return GestureDetector(
    onTap: () async {
      try{
        print("Picker Opened");

        FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a'],
        allowMultiple: false,
      );

      print("result:$result");

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        // 🔥 Size check (100MB)
        final fileSize = await file.length();
        if (fileSize > 100 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("File too large (Max 100MB)")),
          );
          return;
        }

        setState(() {
          selectedFile = file;
        });

        print("Selected: ${file.path}");

      } else{
        print("User cancelled");
      }
    } catch (e){
      print("Error: $e");
    }
    },
    child: Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Center(
        child: selectedFile == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload, size: 30, color: Colors.grey),
                  SizedBox(height: 8),
                  Text("Click to upload audio file"),
                  SizedBox(height: 4),
                  Text(
                    "MP3, WAV, or M4A (Max 100MB)",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              )
            : Text(
                selectedFile!.path.split('/').last,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    ),
  );
}
}