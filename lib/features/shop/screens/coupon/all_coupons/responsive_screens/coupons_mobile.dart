import 'package:baakas_admin/data/repositories/coupons/coupons_repository.dart';
import 'package:flutter/material.dart';
import 'package:baakas_admin/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:baakas_admin/utils/constants/sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CouponsMobileScreen extends StatefulWidget {
  const CouponsMobileScreen({super.key});

  @override
  State<CouponsMobileScreen> createState() => _CouponsMobileScreenState();
}

class _CouponsMobileScreenState extends State<CouponsMobileScreen> {
  late Future<List<Map<String, dynamic>>> _couponsFuture;

  @override
  void initState() {
    super.initState();
    _couponsFuture = _getAllCoupons();
  }

  Future<List<Map<String, dynamic>>> _getAllCoupons() async {
    final snapshot = await FirebaseFirestore.instance.collection('Coupons').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add the document ID to the data
      return data;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(BaakasSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BaakasBreadcrumbsWithHeading(
              heading: 'Coupons',
              breadcrumbItems: ['Coupons'],
            ),
            const SizedBox(height: BaakasSizes.spaceBtwSections * 2),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: _couponsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No coupons found."));
                }

                final coupons = snapshot.data!;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Coupon Code")),
                      DataColumn(label: Text("Discount")),
                      DataColumn(label: Text("Min Purchase")),
                      DataColumn(label: Text("Max Discount")),
                      DataColumn(label: Text("Valid From")),
                      DataColumn(label: Text("Expires On")),
                      DataColumn(label: Text("Used By")),
                      DataColumn(label: Text("Actions")),
                    ],
                    rows: coupons.map((coupon) {
                      return DataRow(
                        cells: [
                          DataCell(Text(coupon['couponCode'] ?? '')),
                          DataCell(Text(
                            coupon['discountType'] == 'percentage'
                                ? "${coupon['discountValue']}%"
                                : "Rs ${coupon['discountValue']}",
                          )),
                          DataCell(Text("Rs ${coupon['minimumPurchase']}")),
                          DataCell(Text("Rs ${coupon['maximumDiscount'] ?? '-'}")),
                          DataCell(Text(_formatDate(coupon['validFrom']))),
                          DataCell(Text(_formatDate(coupon['expirationDate']))),
                          DataCell(Text(coupon['usedBy']?.length.toString() ?? "0")),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () => _deleteCoupon(context, coupon['id']),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCoupon(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return "-";
    DateTime parsed;
    if (date is String) {
      parsed = DateTime.parse(date);
    } else if (date is Timestamp) {
      parsed = date.toDate();
    } else {
      parsed = date;
    }
    return "${parsed.day}/${parsed.month}/${parsed.year}";
  }

  Future<void> _addCoupon(BuildContext context) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final couponCodeController = TextEditingController();
    final discountValueController = TextEditingController();
    final minPurchaseController = TextEditingController();
    final maxDiscountController = TextEditingController();
    bool isPercentage = true;
    DateTime validFrom = DateTime.now();
    DateTime expiresOn = DateTime.now().add(const Duration(days: 30));

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Coupon'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: couponCodeController,
                decoration: const InputDecoration(
                  labelText: 'Coupon Code',
                  hintText: 'e.g. SAVE20',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: discountValueController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Discount Value',
                        hintText: 'e.g. 20',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<bool>(
                    value: isPercentage,
                    items: const [
                      DropdownMenuItem(value: true, child: Text('%')),
                      DropdownMenuItem(value: false, child: Text('Rs')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        isPercentage = value;
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: minPurchaseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Minimum Purchase (Rs)',
                  hintText: 'e.g. 1000',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: maxDiscountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Maximum Discount (Rs)',
                  hintText: 'e.g. 500',
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Valid From'),
                subtitle: Text('${validFrom.day}/${validFrom.month}/${validFrom.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: validFrom,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    validFrom = picked;
                  }
                },
              ),
              ListTile(
                title: const Text('Expires On'),
                subtitle: Text('${expiresOn.day}/${expiresOn.month}/${expiresOn.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: expiresOn,
                    firstDate: validFrom,
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    expiresOn = picked;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (couponCodeController.text.isEmpty ||
                  discountValueController.text.isEmpty ||
                  minPurchaseController.text.isEmpty) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result != true) return;

    final couponData = {
      'couponCode': couponCodeController.text.trim(),
      'discountType': isPercentage ? 'percentage' : 'fixed',
      'discountValue': double.parse(discountValueController.text.trim()),
      'minimumPurchase': double.parse(minPurchaseController.text.trim()),
      'maximumDiscount': maxDiscountController.text.isNotEmpty
          ? double.parse(maxDiscountController.text.trim())
          : null,
      'validFrom': validFrom.toIso8601String(),
      'expirationDate': expiresOn.toIso8601String(),
      'usageLimit': 100,
      'usageLimitPerUser': 1,
      'applicableOn': 'all',
      'eligibleUsers': 'all',
      'selectedUsers': [],
      'usedBy': [],
      'isFeatured': false,
      'isActive': true
    };

    try {
      final couponId = await CouponRepository().createCoupon(couponData);
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Coupon Created Successfully: $couponId')),
      );
      setState(() {
        _couponsFuture = _getAllCoupons();
      });
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error creating coupon: $e')),
      );
    }
  }

  Future<void> _deleteCoupon(BuildContext context, String couponId) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Coupon'),
        content: const Text('Are you sure you want to delete this coupon?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result != true) return;

    try {
      await CouponRepository().deleteCoupon(couponId);
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Coupon deleted successfully')),
      );
      setState(() {
        _couponsFuture = _getAllCoupons();
      });
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error deleting coupon: $e')),
      );
    }
  }
}
