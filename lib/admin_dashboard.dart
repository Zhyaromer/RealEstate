import 'package:flutter/material.dart';
import 'app_style.dart';
import 'auth_service.dart';
import 'dashboard.dart';
import 'details.dart';
import 'firestore_service.dart';
import 'models.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _tabIndex = 0;

  final _tabs = const [
    _AdminTab('Sales', Icons.home_work_outlined),
    _AdminTab('Rentals', Icons.key_rounded),
    _AdminTab('Users', Icons.people_alt_outlined),
    _AdminTab('Approvals', Icons.fact_check_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    if (!AppStore.currentUser.isAdmin) {
      return const DashboardPage();
    }

    return Scaffold(
      backgroundColor: AppStyle.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: IndexedStack(
                index: _tabIndex,
                children: const [
                  _AdminSalesPage(),
                  _AdminRentalsPage(),
                  _AdminUsersPage(),
                  _AdminApprovalsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
      decoration: const BoxDecoration(
        color: AppStyle.primaryDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.admin_panel_settings_rounded,
                color: AppStyle.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Workspace',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppStore.currentUser.username,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.16),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final tab = _tabs[index];
          final selected = _tabIndex == index;
          return ChoiceChip(
            selected: selected,
            avatar: Icon(
              tab.icon,
              size: 18,
              color: selected ? Colors.white : AppStyle.primary,
            ),
            label: Text(tab.label),
            selectedColor: AppStyle.primary,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppStyle.text,
              fontWeight: FontWeight.w800,
            ),
            side: BorderSide(
              color: selected ? AppStyle.primary : Colors.grey.shade200,
            ),
            onSelected: (_) => setState(() => _tabIndex = index),
          );
        },
      ),
    );
  }

  Future<void> _logout() async {
    await AuthService.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }
}

class _AdminSalesPage extends StatelessWidget {
  const _AdminSalesPage();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Property>>(
      stream: FirestoreService.adminPropertiesStream(),
      builder: (context, snapshot) {
        final properties = snapshot.data ?? [];
        return _AdminListShell(
          title: 'Sale Houses',
          count: properties.length,
          actionLabel: 'Add House',
          actionIcon: Icons.add_rounded,
          onAction: () => _showPropertyForm(context),
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          isEmpty: properties.isEmpty,
          emptyIcon: Icons.home_work_outlined,
          emptyText: 'No sale houses yet',
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            itemCount: properties.length,
            itemBuilder: (context, index) => _PropertyAdminCard(
              property: properties[index],
              showApprovalActions: false,
            ),
          ),
        );
      },
    );
  }
}

class _AdminApprovalsPage extends StatelessWidget {
  const _AdminApprovalsPage();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Property>>(
      stream: FirestoreService.pendingPropertiesStream(),
      builder: (context, snapshot) {
        final properties = snapshot.data ?? [];
        return _AdminListShell(
          title: 'Sale Requests',
          count: properties.length,
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          isEmpty: properties.isEmpty,
          emptyIcon: Icons.verified_outlined,
          emptyText: 'No pending sale requests',
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            itemCount: properties.length,
            itemBuilder: (context, index) => _PropertyAdminCard(
              property: properties[index],
              showApprovalActions: true,
            ),
          ),
        );
      },
    );
  }
}

class _AdminRentalsPage extends StatelessWidget {
  const _AdminRentalsPage();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RentalProperty>>(
      stream: FirestoreService.adminRentalsStream(),
      builder: (context, snapshot) {
        final rentals = snapshot.data ?? [];
        return _AdminListShell(
          title: 'Rent Houses',
          count: rentals.length,
          actionLabel: 'Add Rental',
          actionIcon: Icons.add_rounded,
          onAction: () => _showRentalForm(context),
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          isEmpty: rentals.isEmpty,
          emptyIcon: Icons.home_outlined,
          emptyText: 'No rentals yet',
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            itemCount: rentals.length,
            itemBuilder: (context, index) =>
                _RentalAdminCard(rental: rentals[index]),
          ),
        );
      },
    );
  }
}

class _AdminUsersPage extends StatelessWidget {
  const _AdminUsersPage();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserProfile>>(
      stream: FirestoreService.adminUsersStream(),
      builder: (context, snapshot) {
        final users = snapshot.data ?? [];
        return _AdminListShell(
          title: 'Users',
          count: users.length,
          actionLabel: 'Add User',
          actionIcon: Icons.person_add_alt_1_rounded,
          onAction: () => _showUserForm(context),
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          isEmpty: users.isEmpty,
          emptyIcon: Icons.people_outline_rounded,
          emptyText: 'No users yet',
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            itemCount: users.length,
            itemBuilder: (context, index) => _UserAdminCard(user: users[index]),
          ),
        );
      },
    );
  }
}

class _PropertyAdminCard extends StatelessWidget {
  const _PropertyAdminCard({
    required this.property,
    required this.showApprovalActions,
  });

  final Property property;
  final bool showApprovalActions;

  @override
  Widget build(BuildContext context) {
    return _AdminCard(
      image: property.image,
      title: property.title,
      subtitle: property.location,
      meta: '${property.formattedPrice}  |  ${property.bedrooms} bed',
      status: property.status,
      onView: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsPage(property: property),
          ),
        );
      },
      actions: showApprovalActions
          ? [
              _smallAction(
                context,
                'Accept',
                Icons.check_rounded,
                AppStyle.success,
                () => _setPropertyStatus(context, property, 'active'),
              ),
              _smallAction(
                context,
                'Reject',
                Icons.close_rounded,
                AppStyle.danger,
                () => _setPropertyStatus(context, property, 'rejected'),
              ),
            ]
          : [
              _smallAction(
                context,
                'Edit',
                Icons.edit_outlined,
                AppStyle.primary,
                () => _showPropertyForm(context, property: property),
              ),
              _smallAction(
                context,
                'Delete',
                Icons.delete_outline_rounded,
                AppStyle.danger,
                () => _confirmDeleteProperty(context, property),
              ),
            ],
    );
  }
}

class _RentalAdminCard extends StatelessWidget {
  const _RentalAdminCard({required this.rental});

  final RentalProperty rental;

  @override
  Widget build(BuildContext context) {
    return _AdminCard(
      image: rental.image,
      title: rental.title,
      subtitle: rental.location,
      meta: '\$${rental.monthlyRent.toInt()}/mo  |  ${rental.furnishing}',
      status: rental.status,
      actions: [
        _smallAction(
          context,
          'Edit',
          Icons.edit_outlined,
          AppStyle.primary,
          () => _showRentalForm(context, rental: rental),
        ),
        _smallAction(
          context,
          'Delete',
          Icons.delete_outline_rounded,
          AppStyle.danger,
          () => _confirmDeleteRental(context, rental),
        ),
      ],
    );
  }
}

class _UserAdminCard extends StatelessWidget {
  const _UserAdminCard({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppStyle.primary.withOpacity(0.1),
            child: Icon(
              user.isAdmin
                  ? Icons.admin_panel_settings_outlined
                  : Icons.person_outline_rounded,
              color: AppStyle.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.username, style: _titleStyle),
                const SizedBox(height: 4),
                Text(user.email, style: _mutedStyle),
                const SizedBox(height: 4),
                Text('${user.phone}  |  ${user.role}', style: _mutedStyle),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showUserForm(context, user: user),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => _confirmDeleteUser(context, user),
            color: AppStyle.danger,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.status,
    required this.actions,
    this.onView,
  });

  final String image;
  final String title;
  final String subtitle;
  final String meta;
  final String status;
  final List<Widget> actions;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          InkWell(
            onTap: onView,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(18)),
                  child: Image.network(
                    image,
                    width: 105,
                    height: 112,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 105,
                      height: 112,
                      color: Colors.blue.shade50,
                      child: const Icon(Icons.home_work_outlined,
                          color: AppStyle.primary),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(title, style: _titleStyle)),
                            _statusBadge(status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(subtitle, style: _mutedStyle),
                        const SizedBox(height: 8),
                        Text(meta, style: const TextStyle(
                          color: AppStyle.primary,
                          fontWeight: FontWeight.w800,
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(children: actions),
          ),
        ],
      ),
    );
  }
}

class _AdminListShell extends StatelessWidget {
  const _AdminListShell({
    required this.title,
    required this.count,
    required this.isLoading,
    required this.isEmpty,
    required this.emptyIcon,
    required this.emptyText,
    required this.child,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final String title;
  final int count;
  final bool isLoading;
  final bool isEmpty;
  final IconData emptyIcon;
  final String emptyText;
  final Widget child;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$title ($count)',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppStyle.text,
                  ),
                ),
              ),
              if (onAction != null)
                FilledButton.icon(
                  onPressed: onAction,
                  icon: Icon(actionIcon),
                  label: Text(actionLabel ?? 'Add'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : isEmpty
                  ? _EmptyAdminState(icon: emptyIcon, text: emptyText)
                  : child,
        ),
      ],
    );
  }
}

Future<void> _showPropertyForm(BuildContext context, {Property? property}) {
  final title = TextEditingController(text: property?.title ?? '');
  final location = TextEditingController(text: property?.location ?? '');
  final price = TextEditingController(
      text: property == null ? '' : property.price.toStringAsFixed(0));
  final area = TextEditingController(
      text: property == null ? '' : property.area.toStringAsFixed(0));
  final image = TextEditingController(text: property?.image ?? '');
  final description = TextEditingController(text: property?.description ?? '');
  var bedrooms = property?.bedrooms ?? 2;
  var bathrooms = property?.bathrooms ?? 1;
  var propertyType = property?.propertyType ?? 'Apartment';
  var status = property?.status ?? 'active';
  final selectedFeatures = (property?.features.toSet() ?? {'Parking'});
  const featureOptions = [
    'Parking',
    'Garden',
    'Pool',
    'Balcony',
    'Security',
    'Gym',
    'Lift',
    'City View',
  ];
  final formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(property == null ? 'Add Sale House' : 'Edit Sale House'),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogField(title, 'Title', Icons.home_outlined),
                  _dialogField(location, 'Location', Icons.location_on_outlined),
                  _dialogField(image, 'Image URL', Icons.image_outlined),
                  Row(
                    children: [
                      Expanded(child: _dialogField(price, 'Price', Icons.attach_money)),
                      const SizedBox(width: 10),
                      Expanded(child: _dialogField(area, 'Area', Icons.square_foot)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _numberDropdown('Bedrooms', bedrooms,
                            (value) => setState(() => bedrooms = value)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _numberDropdown('Bathrooms', bathrooms,
                            (value) => setState(() => bathrooms = value)),
                      ),
                    ],
                  ),
                  _stringDropdown(
                    'Type',
                    propertyType,
                    const ['Apartment', 'Villa', 'House', 'Penthouse', 'Studio'],
                    (value) => setState(() => propertyType = value),
                  ),
                  _stringDropdown(
                    'Status',
                    status,
                    const ['active', 'pending', 'rejected'],
                    (value) => setState(() => status = value),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Features',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: featureOptions.map((feature) {
                        final selected = selectedFeatures.contains(feature);
                        return FilterChip(
                          label: Text(feature),
                          selected: selected,
                          selectedColor: Colors.blue.shade50,
                          checkmarkColor: AppStyle.primary,
                          side: BorderSide(
                            color: selected
                                ? AppStyle.primary
                                : Colors.grey.shade300,
                          ),
                          labelStyle: TextStyle(
                            color: selected
                                ? AppStyle.primary
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (value) {
                            setState(() {
                              if (value) {
                                selectedFeatures.add(feature);
                              } else {
                                selectedFeatures.remove(feature);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  _dialogField(description, 'Description', Icons.notes_outlined,
                      maxLines: 3),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final saved = Property(
                id: property?.id ?? '',
                title: title.text.trim(),
                location: location.text.trim(),
                price: double.tryParse(price.text.trim()) ?? 0,
                area: double.tryParse(area.text.trim()) ?? 0,
                bedrooms: bedrooms,
                bathrooms: bathrooms,
                image: image.text.trim(),
                images: [image.text.trim()],
                description: description.text.trim(),
                features: selectedFeatures.toList(),
                ownerName: property?.ownerName ?? AppStore.currentUser.username,
                ownerPhone: property?.ownerPhone ?? AppStore.currentUser.phone,
                propertyType: propertyType,
                ownerId: property?.ownerId ?? AppStore.currentUser.uid,
                ownerEmail: property?.ownerEmail ?? AppStore.currentUser.email,
                status: status,
                createdAt: property?.createdAt,
              );
              if (property == null) {
                await FirestoreService.adminAddProperty(saved);
              } else {
                await FirestoreService.adminUpdateProperty(saved);
              }
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

Future<void> _showRentalForm(BuildContext context, {RentalProperty? rental}) {
  final title = TextEditingController(text: rental?.title ?? '');
  final location = TextEditingController(text: rental?.location ?? '');
  final rent = TextEditingController(
      text: rental == null ? '' : rental.monthlyRent.toStringAsFixed(0));
  final area = TextEditingController(
      text: rental == null ? '' : rental.area.toStringAsFixed(0));
  final image = TextEditingController(text: rental?.image ?? '');
  final available = TextEditingController(text: rental?.availableFrom ?? 'Available Now');
  var bedrooms = rental?.bedrooms ?? 2;
  var bathrooms = rental?.bathrooms ?? 1;
  var furnishing = rental?.furnishing ?? 'Unfurnished';
  var status = rental?.status ?? 'active';
  final formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(rental == null ? 'Add Rental' : 'Edit Rental'),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogField(title, 'Title', Icons.home_outlined),
                  _dialogField(location, 'Location', Icons.location_on_outlined),
                  _dialogField(image, 'Image URL', Icons.image_outlined),
                  Row(
                    children: [
                      Expanded(child: _dialogField(rent, 'Monthly Rent', Icons.payments)),
                      const SizedBox(width: 10),
                      Expanded(child: _dialogField(area, 'Area', Icons.square_foot)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _numberDropdown('Bedrooms', bedrooms,
                            (value) => setState(() => bedrooms = value)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _numberDropdown('Bathrooms', bathrooms,
                            (value) => setState(() => bathrooms = value)),
                      ),
                    ],
                  ),
                  _stringDropdown(
                    'Furnishing',
                    furnishing,
                    const ['Fully Furnished', 'Semi Furnished', 'Unfurnished'],
                    (value) => setState(() => furnishing = value),
                  ),
                  _dialogField(available, 'Available From', Icons.event_available),
                  _stringDropdown(
                    'Status',
                    status,
                    const ['active'],
                    (value) => setState(() => status = value),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final saved = RentalProperty(
                id: rental?.id ?? '',
                title: title.text.trim(),
                location: location.text.trim(),
                monthlyRent: double.tryParse(rent.text.trim()) ?? 0,
                area: double.tryParse(area.text.trim()) ?? 0,
                bedrooms: bedrooms,
                bathrooms: bathrooms,
                image: image.text.trim(),
                furnishing: furnishing,
                availableFrom: available.text.trim(),
                ownerId: rental?.ownerId ?? AppStore.currentUser.uid,
                ownerName: rental?.ownerName ?? AppStore.currentUser.username,
                ownerPhone: rental?.ownerPhone ?? AppStore.currentUser.phone,
                status: status,
                createdAt: rental?.createdAt,
              );
              if (rental == null) {
                await FirestoreService.adminAddRental(saved);
              } else {
                await FirestoreService.adminUpdateRental(saved);
              }
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

Future<void> _showUserForm(BuildContext context, {UserProfile? user}) {
  final username = TextEditingController(text: user?.username ?? '');
  final email = TextEditingController(text: user?.email ?? '');
  final phone = TextEditingController(text: user?.phone ?? '');
  var role = user?.role ?? 'user';
  final formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(user == null ? 'Add User Profile' : 'Edit User'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogField(username, 'Username', Icons.person_outline),
                _dialogField(email, 'Email', Icons.email_outlined),
                _dialogField(phone, 'Phone', Icons.phone_outlined),
                _stringDropdown(
                  'Role',
                  role,
                  const ['user', 'admin'],
                  (value) => setState(() => role = value),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await FirestoreService.adminUpsertUser(
                UserProfile(
                  uid: user?.uid ?? '',
                  username: username.text.trim(),
                  email: email.text.trim(),
                  phone: phone.text.trim(),
                  role: role,
                ),
              );
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

Widget _dialogField(
  TextEditingController controller,
  String label,
  IconData icon, {
  int maxLines = 1,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    ),
  );
}

Widget _numberDropdown(String label, int value, ValueChanged<int> onChanged) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<int>(
      value: value.clamp(1, 10).toInt(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      items: List.generate(10, (index) => index + 1)
          .map((item) => DropdownMenuItem(value: item, child: Text('$item')))
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    ),
  );
}

Widget _stringDropdown(
  String label,
  String value,
  List<String> options,
  ValueChanged<String> onChanged,
) {
  final selected = options.contains(value) ? value : options.first;
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<String>(
      value: selected,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      items: options
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    ),
  );
}

Widget _smallAction(
  BuildContext context,
  String label,
  IconData icon,
  Color color,
  VoidCallback onPressed,
) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.45)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    ),
  );
}

Future<void> _setPropertyStatus(
  BuildContext context,
  Property property,
  String status,
) async {
  await FirestoreService.adminSetPropertyStatus(property.id, status);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${property.title} marked $status')),
  );
}

Future<void> _confirmDeleteProperty(BuildContext context, Property property) async {
  final yes = await _confirm(context, 'Delete house?', property.title);
  if (yes) await FirestoreService.adminDeleteProperty(property.id);
}

Future<void> _confirmDeleteRental(BuildContext context, RentalProperty rental) async {
  final yes = await _confirm(context, 'Delete rental?', rental.title);
  if (yes) await FirestoreService.adminDeleteRental(rental.id);
}

Future<void> _confirmDeleteUser(BuildContext context, UserProfile user) async {
  final yes = await _confirm(context, 'Delete user?', user.username);
  if (yes) await FirestoreService.adminDeleteUser(user.uid);
}

Future<bool> _confirm(BuildContext context, String title, String item) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text('Are you sure you want to delete "$item"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: AppStyle.danger),
              child: const Text('Delete'),
            ),
          ],
        ),
      ) ??
      false;
}

Widget _statusBadge(String status) {
  final color = switch (status) {
    'active' => AppStyle.success,
    'pending' => AppStyle.accent,
    'rejected' => AppStyle.danger,
    'deleted' => Colors.grey,
    _ => AppStyle.primary,
  };
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      status,
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
    ),
  );
}

class _EmptyAdminState extends StatelessWidget {
  const _EmptyAdminState({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 74, color: Colors.grey.shade400),
          const SizedBox(height: 14),
          Text(
            text,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _AdminTab {
  const _AdminTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

const _titleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w800,
  color: AppStyle.text,
);

final _mutedStyle = TextStyle(
  color: Colors.grey.shade600,
  fontSize: 13,
);
