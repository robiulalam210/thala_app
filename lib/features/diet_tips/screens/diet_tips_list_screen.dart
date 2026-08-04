import 'package:flutter/material.dart';

import '../models/diet_tip_model.dart';
import '../repository/diet_tips_repository.dart';
import 'diet_tip_detail_screen.dart';

class DietTipsListScreen extends StatefulWidget {
  const DietTipsListScreen({super.key});

  @override
  State<DietTipsListScreen> createState() => _DietTipsListScreenState();
}

class _DietTipsListScreenState extends State<DietTipsListScreen> {
  final _repository = DietTipsRepository();
  List<DietTip>? _tips;

  @override
  void initState() {
    super.initState();
    _repository.getTips().then((tips) {
      if (mounted) setState(() => _tips = tips);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ডায়েট টিপস')),
      body: _tips == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('ডায়েট তথ্য ও নির্দেশনা', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ..._tips!.map(
                  (tip) => GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DietTipDetailScreen(tip: tip)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.article_outlined, color: theme.colorScheme.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tip.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                                const SizedBox(height: 4),
                                Text(
                                  tip.summary,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurface.withOpacity(0.6), height: 1.4),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
