import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/dashboard_api_service.dart';
import 'place_order_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardApiService _apiService = DashboardApiService();
  bool _isLoading = true;
  StatisticsReport? _statistics;
  final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _fetchStatisticsData();
  }

  Future<void> _fetchStatisticsData() async {
    try {
      final data = await _apiService.getStatisticsReport();
      setState(() {
        _statistics = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchStatisticsData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Statistics Report',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_statistics != null) _buildStatisticsCards(),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlaceOrderScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Place New Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildStatisticsCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Orders',
          _statistics!.totalOrder.toString(),
          Colors.blue,
          Icons.shopping_cart,
        ),
        _buildStatCard(
          'Total Revenue',
          currencyFormat.format(_statistics!.totalRevenue),
          Colors.green,
          Icons.attach_money,
        ),
        _buildStatCard(
          'Total Payment',
          currencyFormat.format(_statistics!.totalPayment),
          Colors.purple,
          Icons.payment,
        ),
        _buildStatCard(
          'Total Dues',
          currencyFormat.format(_statistics!.totalDues),
          Colors.orange,
          Icons.account_balance_wallet,
        ),
        _buildStatCard(
          'Total Expense',
          currencyFormat.format(_statistics!.totalExpense),
          Colors.red,
          Icons.shopping_bag,
        ),
        _buildStatCard(
          'Total Withdraw',
          currencyFormat.format(_statistics!.totalWithdraw),
          Colors.teal,
          Icons.money_off,
        ),
        _buildStatCard(
          'Cash In Hand',
          currencyFormat.format(_statistics!.totalCashInHand),
          _statistics!.totalCashInHand >= 0 ? Colors.indigo : Colors.redAccent,
          Icons.account_balance,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}