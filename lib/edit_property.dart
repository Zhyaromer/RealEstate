import 'package:flutter/material.dart';
import 'app_style.dart';
import 'firestore_service.dart';
import 'models.dart';

class EditPropertyPage extends StatefulWidget {
  const EditPropertyPage({
    super.key,
    required this.property,
  });

  final Property property;

  @override
  State<EditPropertyPage> createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _priceController;
  late final TextEditingController _areaController;
  late final TextEditingController _descriptionController;
  late final List<TextEditingController> _imageControllers;

  late int _bedrooms;
  late int _bathrooms;
  late String _propertyType;
  late final Set<String> _selectedFeatures;

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
  void initState() {
    super.initState();
    final property = widget.property;
    _titleController = TextEditingController(text: property.title);
    _locationController = TextEditingController(text: property.location);
    _priceController = TextEditingController(text: property.price.toStringAsFixed(0));
    _areaController = TextEditingController(text: property.area.toStringAsFixed(0));
    _descriptionController = TextEditingController(text: property.description);
    final gallery = property.galleryImages.take(5).toList();
    _imageControllers = List.generate(5, (index) {
      return TextEditingController(text: index < gallery.length ? gallery[index] : '');
    });
    _bedrooms = property.bedrooms;
    _bathrooms = property.bathrooms;
    _selectedFeatures = property.features.toSet();
    _propertyType = _propertyTypes.contains(property.propertyType)
        ? property.propertyType
        : _propertyTypes.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    for (final controller in _imageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPreview(),
                      const SizedBox(height: 18),
                      _buildPropertyType(),
                      const SizedBox(height: 14),
                      _buildField(_titleController, 'Property Title', Icons.home_outlined),
                      const SizedBox(height: 14),
                      _buildField(_locationController, 'Location', Icons.location_on_outlined),
                      const SizedBox(height: 14),
                      _buildImageUrlFields(),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              _priceController,
                              'Price',
                              Icons.attach_money_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildField(
                              _areaController,
                              'Area',
                              Icons.square_foot_outlined,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _buildCounters(),
                      const SizedBox(height: 14),
                      _buildFeatureCheckboxes(),
                      const SizedBox(height: 14),
                      _buildField(
                        _descriptionController,
                        'Description',
                        Icons.notes_outlined,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Save Changes'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppStyle.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
      decoration: const BoxDecoration(
        color: AppStyle.primaryDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.16),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Property',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Update every listing detail',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final previewUrl = _imageControllers.first.text.trim();
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Image.network(
        previewUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 150,
            color: Colors.blue.shade50,
            child: const Icon(
              Icons.home_work_outlined,
              color: AppStyle.primary,
              size: 52,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyType() {
    return DropdownButtonFormField<String>(
      value: _propertyType,
      decoration: _inputDecoration('Property Type', Icons.apartment_outlined),
      items: _propertyTypes.map((type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) {
        if (value != null) setState(() => _propertyType = value);
      },
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool requiredField = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon, hint: hint),
      validator: (value) {
        if (requiredField && (value == null || value.trim().isEmpty)) {
          return 'Please enter $label';
        }
        return null;
      },
      onChanged: label.startsWith('Image URL') ? (_) => setState(() {}) : null,
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
        ...List.generate(_imageControllers.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == _imageControllers.length - 1 ? 0 : 12,
            ),
            child: _buildField(
              _imageControllers[index],
              index == 0 ? 'Image URL 1' : 'Image URL ${index + 1}',
              Icons.image_outlined,
              keyboardType: TextInputType.url,
              requiredField: index == 0,
            ),
          );
        }),
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

  InputDecoration _inputDecoration(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }

  Widget _buildCounters() {
    return Row(
      children: [
        Expanded(
          child: _buildCounter('Bedrooms', Icons.bed_outlined, _bedrooms, (value) {
            setState(() => _bedrooms = value);
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCounter(
            'Bathrooms',
            Icons.bathtub_outlined,
            _bathrooms,
            (value) => setState(() => _bathrooms = value),
          ),
        ),
      ],
    );
  }

  Widget _buildCounter(
    String label,
    IconData icon,
    int value,
    ValueChanged<int> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppStyle.primary, size: 18),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: value > 1 ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: AppStyle.primary,
                ),
              ),
              Text(
                '$value',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: const Icon(Icons.add_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: AppStyle.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final images = _imageControllers
        .map((controller) => controller.text.trim())
        .where((url) => url.isNotEmpty)
        .take(5)
        .toList();

    final updatedProperty = Property(
      id: widget.property.id,
      title: _titleController.text.trim(),
      location: _locationController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? widget.property.price,
      area: double.tryParse(_areaController.text.trim()) ?? widget.property.area,
      bedrooms: _bedrooms,
      bathrooms: _bathrooms,
      image: images.first,
      images: images,
      description: _descriptionController.text.trim(),
      features: _selectedFeatures.toList(),
      ownerName: widget.property.ownerName,
      ownerPhone: widget.property.ownerPhone,
      propertyType: _propertyType,
      ownerId: widget.property.ownerId,
      ownerEmail: widget.property.ownerEmail,
      status: widget.property.status,
      createdAt: widget.property.createdAt,
    );

    try {
      await FirestoreService.updateProperty(updatedProperty);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Property updated'),
          backgroundColor: AppStyle.success,
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to update property: $error'),
          backgroundColor: AppStyle.danger,
        ),
      );
    }
  }
}
