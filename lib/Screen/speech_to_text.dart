import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CollegeFormFilling extends StatefulWidget {
  const CollegeFormFilling({super.key});

  @override
  State<CollegeFormFilling> createState() => _CollegeFormFillingState();
}

class _CollegeFormFillingState extends State<CollegeFormFilling> {
  bool isListening = false;
  late stt.SpeechToText _speechToText;
  String currentField = "";
  String name = "";
  String email = "";
  String phone = "";
  String address = "";
  String course = "";
  String gender = "";
  String nationality = "";
  String previousSchool = "";
  String percentage = "";
  String city = "";
  String state = "";
  double confidence = 1.0;

  @override
  void initState() {
    _speechToText = stt.SpeechToText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("College Admission Form"),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('lib/assets/images/'), // Path to your image
                fit: BoxFit.cover, // Ensures the image covers the entire screen
              ),
            ),
          ),
          // Form content
          SingleChildScrollView(
            reverse: true,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Name", name, (value) => name = value),
                  _buildTextField("Email", email, (value) => email = value),
                  _buildTextField("Phone", phone, (value) => phone = value),
                  _buildTextField(
                      "Address", address, (value) => address = value),
                  _buildTextField("Course", course, (value) => course = value),
                  _buildTextField("Gender", gender, (value) => gender = value),
                  _buildTextField("Nationality", nationality,
                      (value) => nationality = value),
                  _buildTextField("Previous School/University", previousSchool,
                      (value) => previousSchool = value),
                  _buildTextField(
                      "Percentage", percentage, (value) => percentage = value),
                  _buildTextField("City", city, (value) => city = value),
                  _buildTextField("State", state, (value) => state = value),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: _copyFormData,
                      child: const Text(
                        "Copy Form Data",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label, String initialValue, Function(String) onChanged) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: label),
            onTap: () => _setCurrentField(label),
            controller: TextEditingController(text: initialValue),
            onChanged: onChanged,
          ),
        ),
        IconButton(
          icon: Icon(Icons.mic),
          onPressed: () {
            _setCurrentField(label);
            _captureVoice();
          },
        ),
      ],
    );
  }

  void _setCurrentField(String field) {
    setState(() {
      currentField = field;
    });
  }

  void _captureVoice() async {
    if (!isListening) {
      bool listen = await _speechToText.initialize();
      if (listen) {
        setState(() => isListening = true);
        _speechToText.listen(
          onResult: (result) => setState(
            () {
              String spokenText = result.recognizedWords;
              if (result.hasConfidenceRating && result.confidence > 0) {
                confidence = result.confidence;
              }

              // Update the appropriate field based on the current selection
              switch (currentField) {
                case "Name":
                  name = spokenText;
                  break;
                case "Email":
                  email = spokenText;
                  break;
                case "Phone":
                  phone = spokenText;
                  break;
                case "Address":
                  address = spokenText;
                  break;
                case "Course":
                  course = spokenText;
                  break;
                case "Gender":
                  gender = spokenText;
                  break;
                case "Nationality":
                  nationality = spokenText;
                  break;
                case "Previous School/University":
                  previousSchool = spokenText;
                  break;
                case "Percentage":
                  percentage = spokenText;
                  break;
                case "City":
                  city = spokenText;
                  break;
                case "State":
                  state = spokenText;
                  break;
                default:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Select a field to fill")),
                  );
                  break;
              }
            },
          ),
        );
      }
    } else {
      setState(() => isListening = false);
      _speechToText.stop();
    }
  }

  void _copyFormData() {
    String formData =
        "Name: $name\nEmail: $email\nPhone: $phone\nAddress: $address\nCourse: $course\nGender: $gender\nNationality: $nationality\nPrevious School/University: $previousSchool\nPercentage: $percentage\nCity: $city\nState: $state";
    Clipboard.setData(ClipboardData(text: formData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Form data copied to clipboard")),
    );
  }
}
