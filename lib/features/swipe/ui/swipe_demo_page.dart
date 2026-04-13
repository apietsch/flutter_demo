import 'package:flutter/material.dart';

class SwipeDemoPage extends StatefulWidget {
  const SwipeDemoPage({super.key});

  @override
  State<SwipeDemoPage> createState() => _SwipeDemoPageState();
}

class _SwipeDemoPageState extends State<SwipeDemoPage> {
  final List<_SwipeCard> _cards = [
    const _SwipeCard(
      title: 'Mountain Trail',
      subtitle: 'Swipe right to keep this route idea',
      color: Color(0xFF2A9D8F),
    ),
    const _SwipeCard(
      title: 'City Walk',
      subtitle: 'Swipe left to dismiss this option',
      color: Color(0xFFE76F51),
    ),
    const _SwipeCard(
      title: 'Beach Run',
      subtitle: 'Try fast swipes for iOS gesture feel',
      color: Color(0xFF457B9D),
    ),
    const _SwipeCard(
      title: 'Forest Loop',
      subtitle: 'Keep swiping until the stack is empty',
      color: Color(0xFFF4A261),
    ),
  ];

  String _lastAction = 'No swipe yet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Swipe Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Swipe each card left or right.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Last action: $_lastAction',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _cards.isEmpty
                  ? _buildCompletedState(context)
                  : ListView.builder(
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        final card = _cards[index];
                        return Dismissible(
                          key: ValueKey(card.title),
                          direction: DismissDirection.horizontal,
                          background: _swipeBackground(
                            context: context,
                            alignment: Alignment.centerLeft,
                            icon: Icons.favorite,
                            label: 'KEEP',
                            color: Colors.green,
                          ),
                          secondaryBackground: _swipeBackground(
                            context: context,
                            alignment: Alignment.centerRight,
                            icon: Icons.close,
                            label: 'DISMISS',
                            color: Colors.red,
                          ),
                          onDismissed: (direction) {
                            final removed = _cards.removeAt(index);
                            final action =
                                direction == DismissDirection.startToEnd
                                ? 'Kept'
                                : 'Dismissed';
                            setState(() {
                              _lastAction = '$action "${removed.title}"';
                            });
                          },
                          child: _SwipeCardView(card: card),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text(
            'All cards swiped',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              setState(() {
                _cards
                  ..clear()
                  ..addAll([
                    const _SwipeCard(
                      title: 'Mountain Trail',
                      subtitle: 'Swipe right to keep this route idea',
                      color: Color(0xFF2A9D8F),
                    ),
                    const _SwipeCard(
                      title: 'City Walk',
                      subtitle: 'Swipe left to dismiss this option',
                      color: Color(0xFFE76F51),
                    ),
                    const _SwipeCard(
                      title: 'Beach Run',
                      subtitle: 'Try fast swipes for iOS gesture feel',
                      color: Color(0xFF457B9D),
                    ),
                    const _SwipeCard(
                      title: 'Forest Loop',
                      subtitle: 'Keep swiping until the stack is empty',
                      color: Color(0xFFF4A261),
                    ),
                  ]);
                _lastAction = 'Deck reset';
              });
            },
            child: const Text('Reset cards'),
          ),
        ],
      ),
    );
  }

  Widget _swipeBackground({
    required BuildContext context,
    required Alignment alignment,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: alignment == Alignment.centerLeft
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (alignment == Alignment.centerLeft) ...[
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ] else ...[
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: color),
          ],
        ],
      ),
    );
  }
}

class _SwipeCardView extends StatelessWidget {
  const _SwipeCardView({required this.card});

  final _SwipeCard card;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: card.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 130,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                card.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                card.subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeCard {
  const _SwipeCard({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;
}
