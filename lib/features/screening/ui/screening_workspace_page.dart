import 'package:flutter/material.dart';

enum ScreeningStatus { unscreened, include, exclude, maybe }

class PaperItem {
  const PaperItem({
    required this.pmid,
    required this.title,
    required this.author,
    required this.journal,
    required this.year,
    this.status = ScreeningStatus.unscreened,
    this.note,
  });

  final String pmid;
  final String title;
  final String author;
  final String journal;
  final int year;
  final ScreeningStatus status;
  final String? note;

  PaperItem copyWith({
    ScreeningStatus? status,
    String? note,
    bool clearNote = false,
  }) {
    return PaperItem(
      pmid: pmid,
      title: title,
      author: author,
      journal: journal,
      year: year,
      status: status ?? this.status,
      note: clearNote ? null : (note ?? this.note),
    );
  }
}

class ScreeningWorkspacePage extends StatefulWidget {
  const ScreeningWorkspacePage({super.key});

  @override
  State<ScreeningWorkspacePage> createState() => _ScreeningWorkspacePageState();
}

class _ScreeningWorkspacePageState extends State<ScreeningWorkspacePage> {
  late List<PaperItem> _papers;
  ScreeningStatus? _filter;

  @override
  void initState() {
    super.initState();
    _papers = _seedPapers;
  }

  static const List<PaperItem> _seedPapers = [
    PaperItem(
      pmid: '36238127',
      title:
          'Machine learning approaches for predicting clinical outcomes in cancer immunotherapy: a systematic review',
      author: 'Martin Chen',
      journal: 'Journal of Medical AI',
      year: 2024,
      status: ScreeningStatus.exclude,
      note: 'Outdated',
    ),
    PaperItem(
      pmid: '34812713',
      title:
          'CRISPR-Cas9 gene editing in human embryos: ethical considerations and regulatory frameworks',
      author: 'Sarah Kim',
      journal: 'Nature Ethics',
      year: 2024,
      status: ScreeningStatus.include,
    ),
    PaperItem(
      pmid: '35924872',
      title:
          'Long-term effects of COVID-19 vaccination on immune system function: a cohort study',
      author: 'Isabella Garcia',
      journal: 'Vaccine Research',
      year: 2023,
      status: ScreeningStatus.exclude,
      note: 'High risk',
    ),
    PaperItem(
      pmid: '36954213',
      title:
          'Neuroscientific and cognitive decline in Alzheimer\'s disease: recent advances',
      author: 'Kevin Park',
      journal: 'Journal of Neurology',
      year: 2023,
    ),
    PaperItem(
      pmid: '32754189',
      title:
          'A meta-analysis of mRNA vaccine safety outcomes in diverse populations',
      author: 'Priya Nair',
      journal: 'Global Clinical Medicine',
      year: 2022,
    ),
  ];

  Iterable<PaperItem> get _visiblePapers {
    if (_filter == null) {
      return _papers;
    }
    return _papers.where((paper) => paper.status == _filter);
  }

  int _countFor(ScreeningStatus status) {
    return _papers.where((paper) => paper.status == status).length;
  }

  Future<void> _mark(PaperItem paper, ScreeningStatus status) async {
    String? note;
    if (status == ScreeningStatus.exclude) {
      note = await _promptExcludeNote(paper.note);
      if (!mounted) {
        return;
      }
      if (note == null) {
        return;
      }
    }

    setState(() {
      _papers = _papers.map((item) {
        if (item.pmid != paper.pmid) {
          return item;
        }
        if (status == ScreeningStatus.exclude) {
          return item.copyWith(status: status, note: note ?? '');
        }
        return item.copyWith(status: status, clearNote: true);
      }).toList();
    });
  }

  Future<String?> _promptExcludeNote(String? initialValue) async {
    var noteValue = initialValue ?? '';
    final note = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exclude Note'),
          content: TextFormField(
            initialValue: noteValue,
            onChanged: (value) => noteValue = value,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Reason for exclusion',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(noteValue.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    return note;
  }

  @override
  Widget build(BuildContext context) {
    final total = _papers.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Paper Screening Workspace')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paper Screening Workspace',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Review imported papers and make first-pass screening decisions',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    selected: _filter == null,
                    label: 'All Papers ($total)',
                    onTap: () => setState(() => _filter = null),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    selected: _filter == ScreeningStatus.unscreened,
                    label:
                        'Unscreened (${_countFor(ScreeningStatus.unscreened)})',
                    onTap: () =>
                        setState(() => _filter = ScreeningStatus.unscreened),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    selected: _filter == ScreeningStatus.include,
                    label: 'Included (${_countFor(ScreeningStatus.include)})',
                    onTap: () =>
                        setState(() => _filter = ScreeningStatus.include),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    selected: _filter == ScreeningStatus.exclude,
                    label: 'Excluded (${_countFor(ScreeningStatus.exclude)})',
                    onTap: () =>
                        setState(() => _filter = ScreeningStatus.exclude),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    selected: _filter == ScreeningStatus.maybe,
                    label: 'Maybe (${_countFor(ScreeningStatus.maybe)})',
                    onTap: () =>
                        setState(() => _filter = ScreeningStatus.maybe),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _visiblePapers.length,
                separatorBuilder: (_, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final paper = _visiblePapers.elementAt(index);
                  return _PaperCard(
                    paper: paper,
                    onMarkInclude: () => _mark(paper, ScreeningStatus.include),
                    onMarkExclude: () => _mark(paper, ScreeningStatus.exclude),
                    onMarkMaybe: () => _mark(paper, ScreeningStatus.maybe),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.teal.shade600 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _PaperCard extends StatelessWidget {
  const _PaperCard({
    required this.paper,
    required this.onMarkInclude,
    required this.onMarkExclude,
    required this.onMarkMaybe,
  });

  final PaperItem paper;
  final VoidCallback onMarkInclude;
  final VoidCallback onMarkExclude;
  final VoidCallback onMarkMaybe;

  @override
  Widget build(BuildContext context) {
    final metadata =
        'Author: ${paper.author} • Journal: ${paper.journal} • Year: ${paper.year}';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'PMID: ${paper.pmid}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
                const SizedBox(width: 8),
                _StatusBadge(status: paper.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              paper.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(metadata, style: TextStyle(color: Colors.grey.shade700)),
            if ((paper.note ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Note: ${paper.note}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: onMarkInclude,
                  child: const Text('Include'),
                ),
                OutlinedButton(
                  onPressed: onMarkExclude,
                  child: const Text('Exclude'),
                ),
                OutlinedButton(
                  onPressed: onMarkMaybe,
                  child: const Text('Maybe'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ScreeningStatus status;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color color;
    switch (status) {
      case ScreeningStatus.unscreened:
        label = 'Unscreened';
        color = Colors.grey.shade600;
        break;
      case ScreeningStatus.include:
        label = 'Include';
        color = Colors.green.shade600;
        break;
      case ScreeningStatus.exclude:
        label = 'Exclude';
        color = Colors.red.shade600;
        break;
      case ScreeningStatus.maybe:
        label = 'Maybe';
        color = Colors.orange.shade700;
        break;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
