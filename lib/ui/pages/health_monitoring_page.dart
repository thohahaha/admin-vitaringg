import 'package:flutter/material.dart';
import '../theme/neuromorphic_widgets.dart';

class HealthMonitoringPage extends StatefulWidget {
  const HealthMonitoringPage({Key? key}) : super(key: key);

  @override
  State<HealthMonitoringPage> createState() => _HealthMonitoringPageState();
}

class _HealthMonitoringPageState extends State<HealthMonitoringPage> {
  final TextEditingController _notificationController = TextEditingController();
  List<Map<String, dynamic>> healthAlerts = [
    {
      'user': 'Ahmad Rahman',
      'type': 'Heart Rate',
      'value': '120 BPM',
      'status': 'High',
      'time': '10 menit lalu',
      'severity': 'warning'
    },
    {
      'user': 'Siti Aminah',
      'type': 'Blood Pressure',
      'value': '140/90 mmHg',
      'status': 'Elevated',
      'time': '25 menit lalu',
      'severity': 'danger'
    },
    {
      'user': 'Budi Santoso',
      'type': 'Sleep Quality',
      'value': '4.2/10',
      'status': 'Poor',
      'time': '1 jam lalu',
      'severity': 'warning'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeuAppBar(
        title: 'Monitoring Kesehatan',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final padding = isMobile ? 8.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHealthStatistics(isMobile),
                const SizedBox(height: 24),
                _buildHealthInsights(),
                const SizedBox(height: 24),
                _buildAlertSystem(isMobile),
                const SizedBox(height: 24),
                _buildNotificationSender(isMobile),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHealthStatistics(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistik Kesehatan Real-time',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isMobile ? 1.2 : 1.5,
          children: [
            _buildStatCard('Total Users', '2,847', Icons.people, Colors.blue),
            _buildStatCard('Active Today', '1,923', Icons.favorite, Colors.green),
            _buildStatCard('Health Alerts', '12', Icons.warning, Colors.orange),
            _buildStatCard('Critical Cases', '3', Icons.priority_high, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return NeuCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Insights',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        NeuCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInsightItem(
                  'Average Heart Rate',
                  '72 BPM',
                  'Normal range for adults',
                  Colors.green,
                ),
                const Divider(),
                _buildInsightItem(
                  'Sleep Quality',
                  '7.2/10',
                  'Above average quality',
                  Colors.blue,
                ),
                const Divider(),
                _buildInsightItem(
                  'Daily Steps',
                  '8,456',
                  'Target: 10,000 steps',
                  Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightItem(String title, String value, String description, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertSystem(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Health Alerts',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            NeuButton(
              onPressed: () {
                setState(() {
                  healthAlerts.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All alerts cleared')),
                );
              },
              child: const Text('Clear All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: healthAlerts.length,
          itemBuilder: (context, index) {
            final alert = healthAlerts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: NeuCard(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: alert['severity'] == 'danger' 
                        ? Colors.red.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    child: Icon(
                      alert['severity'] == 'danger' 
                          ? Icons.error
                          : Icons.warning,
                      color: alert['severity'] == 'danger' 
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                  title: Text(
                    alert['user'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${alert['type']}: ${alert['value']} - ${alert['status']}'),
                  trailing: isMobile
                      ? null
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              alert['time'],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: alert['severity'] == 'danger' 
                                    ? Colors.red.withOpacity(0.2)
                                    : Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                alert['severity'].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: alert['severity'] == 'danger' 
                                      ? Colors.red
                                      : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                  onTap: () {
                    _showAlertDetails(alert);
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSender(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Send Health Notification',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        NeuCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                NeuTextField(
                  controller: _notificationController,
                  hintText: 'Enter health notification message...',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    NeuButton(
                      onPressed: () {
                        if (_notificationController.text.trim().isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Health notification sent: ${_notificationController.text}',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _notificationController.clear();
                        }
                      },
                      child: const Text('Send to All Users'),
                    ),
                    NeuButton(
                      onPressed: () {
                        if (_notificationController.text.trim().isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Critical alert sent: ${_notificationController.text}',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          _notificationController.clear();
                        }
                      },
                      child: const Text('Send Critical Alert'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAlertDetails(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Health Alert Details'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User: ${alert['user']}'),
              Text('Type: ${alert['type']}'),
              Text('Value: ${alert['value']}'),
              Text('Status: ${alert['status']}'),
              Text('Time: ${alert['time']}'),
              Text('Severity: ${alert['severity'].toUpperCase()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                healthAlerts.remove(alert);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alert resolved')),
              );
            },
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }
}
