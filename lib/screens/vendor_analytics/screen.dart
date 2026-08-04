import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../models/vendor_dashboard_stats.dart';
import '../../providers/store_viewmodel.dart';

class VendorAnalyticsScreen extends StatefulWidget {
  const VendorAnalyticsScreen({super.key});

  @override
  State<VendorAnalyticsScreen> createState() => _VendorAnalyticsScreenState();
}

class _VendorAnalyticsScreenState extends State<VendorAnalyticsScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<StoreViewModel>(context, listen: false)
          .fetchDashboardStats(context: context, showLoader: false);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _statTile(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppUiColor.iconBlack),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: false,
        titleSpacing: 0,
        leading: AppBackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: Consumer<StoreViewModel>(
        builder: (context, model, child) {
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }
          var stats = model.dashboardStats;
          var currencySymbol = "₦";
          var breakdown = stats?.productStatusBreakdown ?? ProductStatusBreakdown(active: 0, draft: 0, inactive: 0);
          var monthlySales = stats?.monthlySales ?? [];
          var maxMonthlyTotal = monthlySales.fold<num>(0, (max, m) => (m.total ?? 0) > max ? (m.total ?? 0) : max);

          return RefreshIndicator(
            onRefresh: () => model.fetchDashboardStats(context: context, showLoader: false),
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 15, UiConstant.horizontalPadding, 10),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _statTile("Total Sales", "$currencySymbol${(stats?.totalSales ?? 0).toStringAsFixed(0)}"),
                        const SizedBox(width: 10),
                        _statTile("Total Orders", "${stats?.totalOrders ?? 0}"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _statTile("Total Products", "${stats?.totalProducts ?? 0}"),
                        const SizedBox(width: 10),
                        _statTile("Active Products", "${breakdown.active ?? 0}"),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Monthly Sales (Last 12 Months)",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          const SizedBox(height: 20),
                          if (monthlySales.every((m) => (m.total ?? 0) == 0)) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: Text("No sales recorded yet")),
                            ),
                          ] else ...[
                            SizedBox(
                              height: 150,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: monthlySales.map((m) {
                                  var heightFraction = maxMonthlyTotal > 0 ? (m.total ?? 0) / maxMonthlyTotal : 0;
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 110 * heightFraction.clamp(0.02, 1.0).toDouble(),
                                            decoration: BoxDecoration(
                                              color: AppUiColor.primary,
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            m.month ?? "",
                                            style: const TextStyle(fontSize: 9, color: AppUiColor.iconBlack),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Product Status",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          const SizedBox(height: 15),
                          _statusRow("Active", breakdown.active ?? 0, breakdown.total, Colors.green),
                          const SizedBox(height: 8),
                          _statusRow("Draft", breakdown.draft ?? 0, breakdown.total, Colors.orange),
                          const SizedBox(height: 8),
                          _statusRow("Inactive", breakdown.inactive ?? 0, breakdown.total, Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statusRow(String label, num value, num total, Color color) {
    var percent = total > 0 ? (value / total) : 0;
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent.toDouble(),
              minHeight: 8,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 30,
          child: Text("$value", textAlign: TextAlign.end, style: const TextStyle(fontSize: 13, color: Colors.black)),
        ),
      ],
    );
  }
}
