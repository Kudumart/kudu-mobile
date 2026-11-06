part of '../screen.dart';

class _VendorOnboardingGuide extends StatefulWidget {
  const _VendorOnboardingGuide();

  @override
  State<_VendorOnboardingGuide> createState() => _VendorOnboardingGuideState();
}

class _VendorOnboardingGuideState extends State<_VendorOnboardingGuide> {
  bool _loading = true;
  bool _hasStore = false;
  bool _kycApproved = false;
  bool _hasProduct = false;
  bool _hasBankAccount = false;
  String? _storeId;

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${StorageService().getString('token')}',
      };

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<dynamic> _get(String path) async {
    final response = await http
        .get(Uri.parse('${ApiEndpoint.baseUrl}$path'), headers: _headers)
        .timeout(const Duration(seconds: 30));
    if (response.statusCode != 200) return null;
    final decoded = jsonDecode(response.body);
    return decoded is Map<String, dynamic> ? decoded['data'] : null;
  }

  bool _approved(dynamic value) =>
      value == true || value == 1 || value?.toString() == '1';

  Future<void> _loadProgress() async {
    if (mounted) setState(() => _loading = true);
    try {
      final results = await Future.wait<dynamic>([
        _get(ApiEndpoint.store),
        _get(ApiEndpoint.fetchVendorProduct),
        _get(ApiEndpoint.kyc),
        _get('/api/vendor/bank/informations'),
      ]);
      final stores = results[0] is List ? results[0] as List : const [];
      final products = results[1] is List ? results[1] as List : const [];
      final kyc = results[2] is Map ? results[2] as Map : const {};
      final accounts = results[3] is List ? results[3] as List : const [];
      if (!mounted) return;
      setState(() {
        _hasStore = stores.isNotEmpty;
        _storeId = stores.isNotEmpty && stores.first is Map
            ? (stores.first as Map)['id']?.toString()
            : null;
        _hasProduct = products.any((product) =>
            product is Map && product['status']?.toString() == 'active');
        _kycApproved = _approved(kyc['isVerified']);
        _hasBankAccount = accounts.isNotEmpty;
      });
    } catch (_) {
      // Keep the guide visible with incomplete steps when status cannot load.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openStore() async {
    await const MyStoreScreenRoute().push(context);
    await _loadProgress();
  }

  Future<void> _openKyc() async {
    await const EditKYCScreenRoute().push(context);
    await _loadProgress();
  }

  Future<void> _openProduct() async {
    if (_storeId == null) {
      await _openStore();
      return;
    }
    await AddProductScreenRoute(
      GetProductModel(),
      storeId: _storeId,
      isEditing: false,
    ).push(context);
    await _loadProgress();
  }

  Future<void> _openWallet() async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const WalletScreen()),
    );
    await _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    final steps = <_VendorOnboardingStep>[
      _VendorOnboardingStep(
        icon: Icons.storefront_outlined,
        title: 'Create your Storefront',
        description: 'Set up your public store and delivery rates.',
        action: 'Create Store',
        completed: _hasStore,
        onTap: _openStore,
      ),
      _VendorOnboardingStep(
        icon: Icons.verified_user_outlined,
        title: 'Complete Identity KYC',
        description: 'Submit your business details for approval.',
        action: _kycApproved ? 'View KYC' : 'Verify Identity',
        completed: _kycApproved,
        onTap: _openKyc,
      ),
      _VendorOnboardingStep(
        icon: Icons.inventory_2_outlined,
        title: 'List your First Product',
        description: 'Upload an item to start receiving orders.',
        action: _hasStore ? 'Add Product' : 'Create Store First',
        completed: _hasProduct,
        onTap: _openProduct,
      ),
      _VendorOnboardingStep(
        icon: Icons.account_balance_outlined,
        title: 'Link Payout Bank Account',
        description: 'Connect an account for escrow withdrawals.',
        action: 'Add Account',
        completed: _hasBankAccount,
        onTap: _openWallet,
      ),
    ];
    final completed = steps.where((step) => step.completed).length;
    if (!_loading && completed == steps.length) return const SizedBox.shrink();
    final progress = completed / steps.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFD8C2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fact_check_outlined,
                  color: AppUiColor.primary, size: 17),
              const SizedBox(width: 7),
              const Expanded(
                child: Text('Vendor Onboarding Guide',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
              Text('$completed of ${steps.length}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 9),
          const Text('Ready to start selling on KuduMart?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text(
            'Complete these steps to receive orders and withdraw your earnings.',
            style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _loading ? null : progress,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFF0F1F3),
                    color: AppUiColor.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('${(progress * 100).round()}%',
                  style: const TextStyle(
                      color: AppUiColor.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          ...steps.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _VendorOnboardingStepCard(
                    number: entry.key + 1,
                    step: entry.value,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _VendorOnboardingStep {
  final IconData icon;
  final String title;
  final String description;
  final String action;
  final bool completed;
  final Future<void> Function() onTap;

  const _VendorOnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.action,
    required this.completed,
    required this.onTap,
  });
}

class _VendorOnboardingStepCard extends StatelessWidget {
  final int number;
  final _VendorOnboardingStep step;

  const _VendorOnboardingStepCard({required this.number, required this.step});

  @override
  Widget build(BuildContext context) {
    final accent =
        step.completed ? const Color(0xFF159455) : AppUiColor.primary;
    return Material(
      color: step.completed ? const Color(0xFFF0FAF5) : const Color(0xFFFFFAF7),
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: step.onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: step.completed
                  ? const Color(0xFFB7E4CD)
                  : const Color(0xFFFFE0CF),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(step.icon, size: 18, color: accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(step.title,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700)),
                        ),
                        Text(step.completed ? 'Done' : 'Step $number',
                            style: TextStyle(
                                color: accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(step.description,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF667085))),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(step.completed ? 'Completed' : step.action,
                            style: TextStyle(
                                color: accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(width: 3),
                        Icon(
                            step.completed
                                ? Icons.check_circle_outline
                                : Icons.arrow_forward,
                            color: accent,
                            size: 15),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
