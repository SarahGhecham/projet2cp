
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> _userData = {};
  bool _isEditing = false;
  @override
  void initState() {
    super.initState();
    _isEditing = false;
    _userData = {
      'profilePicturePath': null,
      'services_count': 5,
      'points': 50,
      'name': 'John',
      'surname': 'Doe',
      'address': '123 Main St, City',
      'gmail': 'john.doe@example.com'
    };
  }

  final ImagePicker _imagePicker = ImagePicker();
  var _pickedImagePath ;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  void _toggleEditing(bool value) {
    setState(() {
      _isEditing = value;
    });
  }

void _saveChanges() {
    
    _userData['name'] = _nameController.text.isNotEmpty
        ? _nameController.text
        : _userData['name'];

    
    _userData['surname'] = _surnameController.text.isNotEmpty
        ? _surnameController.text
        : _userData['surname'];

   
    _userData['gmail'] = _gmailController.text.isNotEmpty
        ? _gmailController.text
        : _userData['gmail'];

   
    _userData['address'] = _addressController.text.isNotEmpty
        ? _addressController.text
        : _userData['address'];

   

    _userData['profilePicturePath'] = _pickedImagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600, // Semibold
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: SizedBox(
              width: 32,
              height: 32,
              child: Image.asset('assets/images/settings.png'),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 390,
                  height: 272,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.26),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    FractionalTranslation(
                      translation: const Offset(
                        0,
                        0.78,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 168,
                          height: 174,
                          child: GestureDetector(
                            onTap: () async {
                              if (_isEditing) {
                                final picker = ImagePicker();
                                final pickedFile = await picker.getImage(
                                  source: ImageSource.gallery,
                                );

                                if (pickedFile != null) {
                                  setState(() {
                                    _pickedImagePath = pickedFile.path;
                                    _userData['profilePicturePath'] =
                                        _pickedImagePath;
                                  });
                                }
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: _userData['profilePicturePath'] != null
                                  ? Image.file(
                                      File(_userData['profilePicturePath']),
                                      width: 168,
                                      height: 174,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/l.png',
                                      width: 168,
                                      height: 174,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 72.0), 
                  child: SizedBox(
                    width: 98,
                    height: 33,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isEditing) {
                          _saveChanges();
                          _toggleEditing(false);
                        } else {
                          _toggleEditing(true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor: const Color(0xFFFF8787),
                      ),
                      child: Text(
                        _isEditing ? 'Valider' : 'Editer',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 170,
                  height: 61,
                  margin: const EdgeInsets.only(left: 00, bottom: 00),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6E3DC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Service',
                            style: TextStyle(
                              color: Color(0xFFFF8787),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _userData['services_count'].toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: double.infinity,
                        color: const Color(0xFFDCC8C5),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Points',
                            style: TextStyle(
                              color: Color(0xFFFF8787),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _userData['points'].toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
           
            Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 116,
                      height: 41,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCC8C5).withOpacity(0.22),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFDCC8C5),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: _isEditing
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter name',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: TextStyle(
                                   color: _userData['name'] != null &&
                                          _userData['name'].isNotEmpty
                                      ? Colors.black
                                      : Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Text(
                                _userData['name'] != null &&
                                        _userData['name'].isNotEmpty
                                    ? _userData['name']
                                    : ' name',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Container(
                      width: 116,
                      height: 41,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCC8C5).withOpacity(0.22),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFDCC8C5),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: _isEditing
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: _surnameController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter surname',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Text(
                                _userData['surname'] != null &&
                                        _userData['surname'].isNotEmpty
                                    ? _userData['surname']
                                    : 'surname',
                                style: TextStyle(
                                 color: _userData['surname'] != null &&
                                          _userData['surname'].isNotEmpty
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 277,
                      height: 41,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCC8C5).withOpacity(0.22),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFDCC8C5),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: _isEditing
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: _gmailController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Gmail',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Text(
                                _userData['gmail'] != null &&
                                        _userData['gmail'].isNotEmpty
                                    ? _userData['gmail']
                                    : 'Gmail',
                                style: TextStyle(
                                  color: _userData['gmail'] != null &&
                                          _userData['gmail'].isNotEmpty
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 277,
                      height: 51,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCC8C5).withOpacity(0.22),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFDCC8C5),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: _isEditing
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: _addressController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Address',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Text(
                                _userData['address'] != null &&
                                        _userData['address'].isNotEmpty
                                    ? _userData['address']
                                    : 'Adress',
                                style: TextStyle(
                                   color: _userData['address'] != null &&
                                          _userData['address'].isNotEmpty
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
