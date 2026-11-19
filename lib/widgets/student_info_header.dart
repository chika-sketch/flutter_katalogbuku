import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/book_providers.dart';

class StudentInfoHeader extends ConsumerWidget {
  const StudentInfoHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(nameProvider);
    final npm = ref.watch(npmProvider);
    final books = ref.watch(booksProvider);
    final infoSummary = ref.watch(infoProvider);
    final hiddenIds = ref.watch(hiddenDescriptionIdsProvider);

    final allHidden =
        books.isNotEmpty && hiddenIds.length == books.length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NPM: $npm',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  avatar: const Icon(Icons.library_books, size: 18),
                  label: Text(
                    '${books.length} Buku',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Text(
                  infoSummary,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    if (allHidden) {
                      ref.read(hiddenDescriptionIdsProvider.notifier).state =
                          <String>{};
                    } else {
                      ref.read(hiddenDescriptionIdsProvider.notifier).state =
                          books.map((b) => b.id).toSet();
                    }
                  },
                  icon: Icon(
                    allHidden ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                  ),
                  label: Text(
                    allHidden
                        ? 'Tampilkan Semua Deskripsi'
                        : 'Sembunyikan Semua Deskripsi',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}