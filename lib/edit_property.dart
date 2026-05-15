import 'package:flutter/material.dart';
import 'app_style.dart';
import 'models.dart';

class EditPropertyPage extends StatefulWidget {
  const EditPropertyPage({
    super.key,
    required this.property,
    required this.propertyIndex,
  });

  final Property property;
  final int propertyIndex;

  @override
  State<EditPropertyPage> createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _priceController;
  late final TextEditingController _areaController;
  late final TextEditingController _imageController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _featuresController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _ownerPhoneController;

  late int _bedrooms;
  late int _bathrooms;
  late String _propertyType;

  final List<String> _propertyTypes = [
    'Apartment',
    'Villa',
    'House',
    'Penthouse',
    'Studio',
  ];

  @override
  void initState() {
    super.initState();
    final property = widget.property;
    _titleController = TextEditingController(text: property.title);
    _locationController = TextEditingController(text: property.location);
    _priceController = TextEditingController(text: property.price.toStringAsFixed(0));
    _areaController = TextEditingController(text: property.area.toStringAsFixed(0));
    _imageController = TextEditingController(text: property.image);
    _descriptionController = TextEditingController(text: property.description);
    _featuresController = TextEditingController(text: property.features.join(', '));
    _ownerNameController = TextEditingController(text: property.ownerName);
    _ownerPhoneController = TextEditingController(text: property.ownerPhone);
    _bedrooms = property.bedrooms;
    _bathrooms = property.bathrooms;
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
    _imageController.dispose();
    _descriptionController.dispose();
    _featuresController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
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
                      _buildField(
                        _ownerNameController,
                        'Owner Name',
                        Icons.person_outline,
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        _ownerPhoneController,
                        'Owner Phone',
                        Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        _imageController,
                        'Image URL',
                        Icons.image_outlined,
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              _priceController,
                              'Price',
                              Icons.payments_outlined,
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
                      _buildField(
                        _featuresController,
                        'Features',
                        Icons.check_circle_outline,
                        hint: 'Garden, Parking, Security',
                      ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Image.network(
        _imageController.text,
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
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon, hint: hint),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onChanged: label == 'Image URL' ? (_) => setState(() {}) : null,
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final features = _featuresController.text
        .split(',')
        .map((feature) => feature.trim())
        .where((feature) => feature.isNotEmpty)
        .toList();

    AppStore.myProperties[widget.propertyIndex] = Property(
      id: widget.property.id,
      title: _titleController.text.trim(),
      location: _locationController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? widget.property.price,
      area: double.tryParse(_areaController.text.trim()) ?? widget.property.area,
      bedrooms: _bedrooms,
      bathrooms: _bathrooms,
      image: _imageController.text.trim(),
      images: [
        _imageController.text.trim(),
        ...widget.property.images,
      ].where((url) => url.isNotEmpty).toSet().toList(),
      description: _descriptionController.text.trim(),
      features: features,
      ownerName: _ownerNameController.text.trim(),
      ownerPhone: _ownerPhoneController.text.trim(),
      propertyType: _propertyType,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Property updated'),
        backgroundColor: AppStyle.success,
      ),
    );
    Navigator.pop(context);
  }
}
