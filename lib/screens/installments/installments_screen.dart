import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../core/shared_widgets/overlay/overlay.dart';
import '../../providers/home_provider.dart';

class InstallmentsScreen extends StatefulWidget {
  const InstallmentsScreen({super.key});

  @override
  State<InstallmentsScreen> createState() => _InstallmentsScreenState();
}

class _InstallmentsScreenState extends State<InstallmentsScreen> {
  bool _loading = true;
  List<dynamic> _plans = [];
  String? _payingMilestoneId;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() => _loading = true);
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    final plans = await homeViewModel.fetchUserInstallmentPlans();
    if (mounted) {
      setState(() {
        _plans = plans;
        _loading = false;
      });
    }
  }

  String _formatMoney(dynamic amount) {
    final numVal = num.tryParse(amount?.toString() ?? "0") ?? 0;
    return NumberFormat.currency(locale: "en-US", symbol: "₦").format(numVal);
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return const Color(0xFF16A34A);
      case 'active':
        return AppUiColor.primary;
      case 'cancelled':
      case 'defaulted':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> _payMilestone(dynamic milestone, dynamic plan) async {
    final milestoneId = milestone['id']?.toString() ?? "";
    final amount = num.tryParse(milestone['amount']?.toString() ?? "0")?.toDouble() ?? 0.0;
    if (milestoneId.isEmpty || amount <= 0) return;

    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    final walletBal = num.tryParse(homeViewModel.userData?.wallet?.toString() ?? "0")?.toDouble() ?? 0.0;

    bool useWallet = false;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text("Pay Milestone", style: TextStyle(fontWeight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Milestone #${milestone['milestone_number'] ?? '1'}"),
                  const SizedBox(height: 8),
                  Text(
                    _formatMoney(amount),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppUiColor.primary),
                  ),
                  const SizedBox(height: 16),
                  if (walletBal > 0) ...[
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Apply Wallet Balance (${_formatMoney(walletBal)})",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      value: useWallet,
                      activeColor: AppUiColor.primary,
                      onChanged: (val) {
                        setModalState(() => useWallet = val ?? false);
                      },
                    ),
                  ],
                  const Text(
                    "Payments are held in secure escrow until your final installment is complete and the product is delivered.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppUiColor.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text("Proceed to Pay"),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirm != true) return;

    setState(() => _payingMilestoneId = milestoneId);
    AppUiOverlay.showLoadingIndicator(context);

    try {
      final prepared = await homeViewModel.prepareMilestonePayment(milestoneId, useWallet: useWallet);
      AppUiOverlay.dismissLoadingIndicator();

      if (prepared == null) {
        if (mounted) {
          AppUiOverlay().showErrorSnackbarMessage(context, message: "Could not prepare milestone payment");
          setState(() => _payingMilestoneId = null);
        }
        return;
      }

      final isPureWallet = prepared['paidWithWallet'] == true;
      final refId = prepared['refId']?.toString() ?? "";
      final amountToPay = (num.tryParse(prepared['amountToPay']?.toString() ?? "0") ?? 0).toDouble();

      if (isPureWallet && refId.isNotEmpty) {
        final confirmed = await homeViewModel.confirmMilestonePayment(milestoneId, refId);
        if (confirmed && mounted) {
          AppUiOverlay().showSuccessSnackbarMessage(context, message: "Milestone paid successfully via wallet!");
          await _loadPlans();
        }
      } else {
        if (refId.isEmpty) {
          if (mounted) {
            AppUiOverlay().showErrorSnackbarMessage(context, message: "Payment session could not be established");
          }
          return;
        }

        final payResult = await homeViewModel.initiatePayment(
          context: context,
          amount: amountToPay > 0 ? amountToPay : amount,
          reference: refId,
        );

        if (payResult != null && payResult.reference != null && payResult.reference!.isNotEmpty) {
          final confirmed = await homeViewModel.confirmMilestonePayment(milestoneId, payResult.reference!);
          if (confirmed && mounted) {
            AppUiOverlay().showSuccessSnackbarMessage(context, message: "Milestone payment confirmed!");
            await _loadPlans();
          }
        }
      }
    } catch (e) {
      AppUiOverlay.dismissLoadingIndicator();
      if (mounted) {
        AppUiOverlay().showErrorSnackbarMessage(context, message: "Payment error: $e");
      }
    } finally {
      if (mounted) {
        setState(() => _payingMilestoneId = null);
      }
    }
  }

  Future<void> _cancelPlan(dynamic plan) async {
    final planId = plan['id']?.toString() ?? "";
    if (planId.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cancel Layaway Plan"),
        content: const Text(
          "Are you sure you want to cancel this layaway plan? Any refundable balance will be credited to your KuduMart wallet minus the standard layaway cancellation fee.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Keep Plan")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Cancel Plan"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    AppUiOverlay.showLoadingIndicator(context);
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    final success = await homeViewModel.cancelInstallmentPlan(planId);
    AppUiOverlay.dismissLoadingIndicator();

    if (success && mounted) {
      AppUiOverlay().showSuccessSnackbarMessage(context, message: "Layaway plan cancelled");
      await _loadPlans();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          "Layaway & Installments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _plans.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadPlans,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _plans.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final plan = _plans[index];
                      return _buildPlanCard(plan);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppUiColor.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_month_outlined, size: 48, color: AppUiColor.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              "No Active Layaway Plans",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              "You can buy products on KuduMart in convenient installments using Layaway. Choose 'Pay in Installments' during checkout to reserve items with just 20% down.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(dynamic plan) {
    final product = plan['product'] as Map<String, dynamic>?;
    final productName = product?['name']?.toString() ?? "Product";
    final productImage = product?['image_url']?.toString() ?? "";
    final status = plan['status']?.toString() ?? "active";
    final totalAmount = plan['total_amount'];
    final remainingBalance = plan['remaining_balance'];
    final milestones = (plan['milestones'] as List? ?? []);

    final paidMilestones = milestones.where((m) => m['status']?.toString().toLowerCase() == 'paid').length;
    final totalMilestones = milestones.length;
    final progress = totalMilestones > 0 ? (paidMilestones / totalMilestones) : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Product Name + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (productImage.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      productImage,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 52,
                        height: 52,
                        color: Colors.grey[100],
                        child: const Icon(Icons.image_not_supported_outlined, size: 20),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Total: ${_formatMoney(totalAmount)}",
                        style: TextStyle(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _statusColor(status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$paidMilestones of $totalMilestones Payments Made",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppUiColor.primary),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  status == 'completed' ? const Color(0xFF16A34A) : AppUiColor.primary,
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status == 'completed'
                  ? "Item dispatched for delivery!"
                  : "Remaining: ${_formatMoney(remainingBalance)}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: status == 'completed' ? const Color(0xFF16A34A) : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),

            // Milestones list
            const Text(
              "Payment Milestones",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...milestones.map((m) {
              final mStatus = m['status']?.toString().toLowerCase() ?? "pending";
              final isPaid = mStatus == 'paid';
              final mNum = m['milestone_number'] ?? '1';
              final mAmount = m['amount'];
              final mDueDate = m['due_date']?.toString() ?? "";
              final isPayingThis = _payingMilestoneId == m['id']?.toString();

              String formattedDue = mDueDate;
              if (mDueDate.isNotEmpty) {
                try {
                  formattedDue = DateFormat('MMM dd, yyyy').format(DateTime.parse(mDueDate));
                } catch (_) {}
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isPaid ? const Color(0xFFF0FDF4) : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isPaid ? const Color(0xFFBBF7D0) : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPaid ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      size: 18,
                      color: isPaid ? const Color(0xFF16A34A) : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Milestone #$mNum: ${_formatMoney(mAmount)}",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isPaid ? const Color(0xFF16A34A) : Colors.black87,
                            ),
                          ),
                          if (formattedDue.isNotEmpty)
                            Text(
                              isPaid ? "Paid" : "Due: $formattedDue",
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                        ],
                      ),
                    ),
                    if (!isPaid && status == 'active')
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppUiColor.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          onPressed: isPayingThis ? null : () => _payMilestone(m, plan),
                          child: isPayingThis
                              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text("Pay Now"),
                        ),
                      ),
                  ],
                ),
              );
            }),

            // Cancel action
            if (status == 'active') ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red[700],
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () => _cancelPlan(plan),
                  child: const Text("Cancel Layaway Plan"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
