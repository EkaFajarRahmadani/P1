import 'package:flutter/material.dart';

import '../models/student.dart';
import '../widgets/profile_card.dart';

/// Displays the student profile and allows its details to be edited.
class ProfileScreen extends StatefulWidget {
  /// Creates the profile screen.
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Student _student = const Student(
    name: 'Nama Mahasiswa',
    nim: 'NIM belum diisi',
    programStudi: 'Program Studi',
    email: 'email@example.com',
  );

  Future<void> _editProfile() async {
    final updatedStudent = await showDialog<Student>(
      context: context,
      builder: (context) => _EditProfileDialog(student: _student),
    );

    if (!mounted || updatedStudent == null) {
      return;
    }

    setState(() {
      _student = updatedStudent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Informasi Profil',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data diri mahasiswa',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  ProfileCard(student: _student),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    key: const Key('edit-profile-button'),
                    onPressed: _editProfile,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profil'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({required this.student});

  final Student student;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _nimController;
  late final TextEditingController _programStudiController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _nimController = TextEditingController(text: widget.student.nim);
    _programStudiController = TextEditingController(
      text: widget.student.programStudi,
    );
    _emailController = TextEditingController(text: widget.student.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _programStudiController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(
      Student(
        name: _nameController.text.trim(),
        nim: _nimController.text.trim(),
        programStudi: _programStudiController.text.trim(),
        email: _emailController.text.trim(),
      ),
    );
  }

  String? _requiredField(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profil'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('name-field'),
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                textCapitalization: TextCapitalization.words,
                validator: (value) => _requiredField(value, 'Nama'),
              ),
              TextFormField(
                key: const Key('nim-field'),
                controller: _nimController,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (value) => _requiredField(value, 'NIM'),
              ),
              TextFormField(
                key: const Key('program-studi-field'),
                controller: _programStudiController,
                decoration: const InputDecoration(labelText: 'Program Studi'),
                textCapitalization: TextCapitalization.words,
                validator: (value) => _requiredField(value, 'Program studi'),
              ),
              TextFormField(
                key: const Key('email-field'),
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final requiredError = _requiredField(value, 'Email');
                  if (requiredError != null) {
                    return requiredError;
                  }
                  if (!value!.contains('@')) {
                    return 'Masukkan alamat email yang valid';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('save-profile-button'),
          onPressed: _saveProfile,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
