
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String nama;
  final String telepon;
  final String email;
  final String avatar;

  const EditProfilePage({
    super.key,
    required this.nama,
    required this.telepon,
    required this.email,
    required this.avatar,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaController;
  late final TextEditingController _teleponController;
  late final TextEditingController _emailController;
  late String _selectedAvatar;

  static const Color purple = Color(0xFF9449B8);
  static const Color pink = Color(0xFFE0468F);

  final List<String> avatars = [
    'assets/images/avatar_siti.png',
    'assets/images/avatar_raka.png',
    'assets/images/avatar_sari.png',
    'assets/images/avatar_4.png',
  ];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.nama);
    _teleponController = TextEditingController(text: widget.telepon);
    _emailController = TextEditingController(text: widget.email);
    _selectedAvatar = widget.avatar;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD7D7D7),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD7D7D7),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: purple,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarOption(String path) {
    final selected = _selectedAvatar == path;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAvatar = path;
        });
      },
      child: Container(
        width: 51,
        height: 51,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: selected ? purple : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            path,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _simpanPerubahan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(context, <String, String>{
      'nama': _namaController.text.trim(),
      'telepon': _teleponController.text.trim(),
      'email': _emailController.text.trim(),
      'avatar': _selectedAvatar,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 38,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),

                          const Center(
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 23),

                          _inputField(
                            label: 'Nama Lengkap',
                            controller: _namaController,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Nama wajib diisi';
                              }
                              return null;
                            },
                          ),

                          _inputField(
                            label: 'Nomor HP.',
                            controller: _teleponController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              final nomor = value?.trim() ?? '';
                              if (nomor.isEmpty) {
                                return 'Nomor HP wajib diisi';
                              }
                              if (!RegExp(
                                r'^[0-9+\s-]{9,20}$',
                              ).hasMatch(nomor)) {
                                return 'Nomor HP tidak valid';
                              }
                              return null;
                            },
                          ),

                          _inputField(
                            label: 'Email',
                            controller: _emailController,
                            keyboardType:
                                TextInputType.emailAddress,
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (!RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              ).hasMatch(email)) {
                                return 'Masukkan email yang valid';
                              }
                              return null;
                            },
                          ),

                          const Text(
                            'Avatar',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Wrap(
                            spacing: 7,
                            runSpacing: 7,
                            children: [
                              for (final path in avatars)
                                _avatarOption(path),
                            ],
                          ),

                          const SizedBox(height: 95),

                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [purple, pink],
                                ),
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                onPressed: _simpanPerubahan,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.transparent,
                                  shadowColor:
                                      Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Simpan Perubahan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
