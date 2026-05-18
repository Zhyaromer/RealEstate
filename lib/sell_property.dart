import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'app_style.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'models.dart';

/// Sell Property Page
/// Allows users to list their property for sale
/// Includes form for property details, photos, and pricing
class SellPropertyPage extends StatefulWidget {
  const SellPropertyPage({super.key});

  @override
  State<SellPropertyPage> createState() => SellPropertyPageState();
}

class SellPropertyPageState extends State<SellPropertyPage> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// wargrtni datay naw textfillds
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _areaController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<Uint8List> _imageBytesList = [];
  bool _isSubmitting = false;

  /// Selected values
  int _bedrooms = 2;
  int _bathrooms = 1;
  String _propertyType = 'Apartment';
  final Set<String> _selectedFeatures = {'Parking'};

  /// List of property types
  final List<String> _propertyTypes = [
    'Apartment',
    'Villa',
    'House',
    'Penthouse',
    'Studio',
  ];

  final List<String> _featureOptions = [
    'Parking',
    'Garden',
    'Pool',
    'Balcony',
    'Security',
    'Gym',
    'Lift',
    'City View',
  ];

  @override
  void dispose() {
    /// srrenaway datay naw controllerakan
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_imageBytesList.length >= 5) return;

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      _imageBytesList.add(bytes);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _imageBytesList.removeAt(index);
    });
  }

  /// check prkranaway filedakan
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imageBytesList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose at least one property image.'),
          backgroundColor: AppStyle.danger,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final price = double.tryParse(_priceController.text.trim()) ?? 0;
      final area = double.tryParse(_areaController.text.trim()) ?? 0;
      var images = <String>[];
      try {
        images = await FirestoreService.uploadImagesToImgBB(_imageBytesList);
      } catch (error) {
        debugPrint('Image upload failed, saving without image: $error');
      }
      await FirestoreService.addProperty(
        Property(
          id: '',
          title: _titleController.text.trim(),
          location: _locationController.text.trim(),
          price: price,
          area: area,
          bedrooms: _bedrooms,
          bathrooms: _bathrooms,
          image: images.isEmpty ? '' : images.first,
          images: images,
          description: _descriptionController.text.trim(),
          features: _selectedFeatures.toList(),
          ownerName: AppStore.currentUser.username,
          ownerPhone: AppStore.currentUser.phone,
          propertyType: _propertyType,
          ownerId: AuthService.currentUser?.uid ?? '',
          ownerEmail: AuthService.currentUser?.email ?? '',
          status: 'active',
        ),
      );
      if (!mounted) return;
      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Property submitted for admin approval.'),
          backgroundColor: AppStyle.success,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to list property: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _locationController.clear();
    _priceController.clear();
    _areaController.clear();
    _descriptionController.clear();
    setState(() {
      _imageBytesList.clear();
      _bedrooms = 2;
      _bathrooms = 1;
      _propertyType = 'Apartment';
      _selectedFeatures
        ..clear()
        ..add('Parking');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.background,
      body: Container(
        color: AppStyle.primaryDark,
        child: SafeArea(
          child: Column(
            children: [
              /// Header
              _buildHeader(),

              /// Form content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Instructions
                          _buildInstructions(),
                          const SizedBox(height: 24),

                          /// Property Type Dropdown
                          _buildPropertyTypeDropdown(),
                          const SizedBox(height: 16),

                          /// Title Field
                          _buildTextField(
                            controller: _titleController,
                            label: 'Property Title',
                            hint: 'e.g., Modern 3BHK Apartment',
                            icon: Icons.home,
                          ),
                          const SizedBox(height: 16),

                          /// Location Field
                          _buildTextField(
                            controller: _locationController,
                            label: 'Location',
                            hint: 'e.g., Mumbai, Maharashtra',
                            icon: Icons.location_on,
                          ),
                          const SizedBox(height: 16),

                          _buildImageUrlFields(),
                          const SizedBox(height: 16),

                          /// Price Field
                          _buildTextField(
                            controller: _priceController,
                            label: 'Price (\$)',
                            hint: 'e.g., 5000000',
                            icon: Icons.attach_money_rounded,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          /// Area Field
                          _buildTextField(
                            controller: _areaController,
                            label: 'Area (sq.ft)',
                            hint: 'e.g., 1500',
                            icon: Icons.photo_size_select_small,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 24),

                          /// Bedrooms and Bathrooms
                          _buildRoomSelectors(),
                          const SizedBox(height: 24),

                          _buildFeatureCheckboxes(),
                          const SizedBox(height: 24),

                          /// Description Field
                          _buildDescriptionField(),
                          const SizedBox(height: 32),

                          /// Submit Button
                          _buildSubmitButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Button garranawa
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sell Property',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'List your property for sale',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// box dawakani formaka
  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppStyle.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Fill in the details below to list your property',
              style: TextStyle(
                color: AppStyle.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// listy datakani naw dropdown
  Widget _buildPropertyTypeDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _propertyType,
      decoration: InputDecoration(
        labelText: 'Property Type',
        prefixIcon: const Icon(Icons.apartment),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: _propertyTypes.map((type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) {
        setState(() => _propertyType = value!);
      },
    );
  }

  /// required textfield
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool requiredField = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (requiredField && (value == null || value.trim().isEmpty)) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  /// dyari krdni zhmaray zhwrakan
  Widget _buildRoomSelectors() {
    return Row(
      children: [
        /// Bedrooms
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bedrooms',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_bedrooms > 1) {
                          setState(() => _bedrooms--);
                        }
                      },
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: AppStyle.primary,
                      ),
                    ),
                    Text(
                      '$_bedrooms',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => _bedrooms++);
                      },
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: AppStyle.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        /// zhmaray bathroomakan
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bathrooms',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_bathrooms > 1) {
                          setState(() => _bathrooms--);
                        }
                      },
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: AppStyle.primary,
                      ),
                    ),
                    Text(
                      '$_bathrooms',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => _bathrooms++);
                      },
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: AppStyle.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// text filed description
  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'Describe your property...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter description';
        }
        return null;
      },
    );
  }

  Widget _buildImageUrlFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Images',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...List.generate(_imageBytesList.length, (index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.memory(
                      _imageBytesList[index],
                      width: 92,
                      height: 92,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: InkWell(
                      onTap: () => _removeImage(index),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            if (_imageBytesList.length < 5)
              InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(
                    Icons.add_a_photo_outlined,
                    color: AppStyle.primary,
                    size: 30,
                  ),
                ),
              ),
          ],
        ),
        if (_imageBytesList.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Choose at least one image from your gallery.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeatureCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Features',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _featureOptions.map((feature) {
            final selected = _selectedFeatures.contains(feature);
            return FilterChip(
              label: Text(feature),
              selected: selected,
              onSelected: (value) {
                setState(() {
                  if (value) {
                    _selectedFeatures.add(feature);
                  } else {
                    _selectedFeatures.remove(feature);
                  }
                });
              },
              selectedColor: Colors.blue.shade50,
              checkmarkColor: AppStyle.primary,
              side: BorderSide(
                color: selected ? AppStyle.primary : Colors.grey.shade300,
              ),
              labelStyle: TextStyle(
                color: selected ? AppStyle.primary : Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  ///button submit krdnaway formaka
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : const Text(
                'List Property',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
