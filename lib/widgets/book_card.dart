import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../providers/book_providers.dart';

class BookCard extends ConsumerWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hiddenIds = ref.watch(hiddenDescriptionIdsProvider);
    final isDescriptionVisible = !hiddenIds.contains(book.id);
    final colorScheme = Theme.of(context).colorScheme;

    // Penanganan null safety untuk deskripsi buku
    final hasDescription =
        book.description != null && book.description!.trim().isNotEmpty;
    final descriptionText = hasDescription
        ? book.description!
        : 'Tidak ada deskripsi untuk buku ini.';

    void toggleDescription() {
      final current = {...ref.read(hiddenDescriptionIdsProvider)};
      if (current.contains(book.id)) {
        current.remove(book.id);
      } else {
        current.add(book.id);
      }
      ref.read(hiddenDescriptionIdsProvider.notifier).state = current;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isDescriptionVisible
            ? colorScheme.surfaceContainerLow
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDescriptionVisible
              ? colorScheme.primary.withValues(alpha: 0.45)
              : colorScheme.outlineVariant,
          width: isDescriptionVisible ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDescriptionVisible ? 0.06 : 0.02),
            blurRadius: isDescriptionVisible ? 10 : 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: toggleDescription,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookCover(context, colorScheme),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${book.author} • ${book.year}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Implicit animation kedua: transisi halus tampil/sembunyi deskripsi
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 280),
                firstCurve: Curves.easeOut,
                secondCurve: Curves.easeIn,
                sizeCurve: Curves.easeInOut,
                crossFadeState: isDescriptionVisible
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: hasDescription
                        ? colorScheme.surface
                        : colorScheme.errorContainer.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    descriptionText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: hasDescription
                              ? FontStyle.normal
                              : FontStyle.italic,
                          color: hasDescription
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
                secondChild: const SizedBox(width: double.infinity, height: 0),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: toggleDescription,
                  icon: Icon(
                    isDescriptionVisible
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 18,
                  ),
                  label: Text(
                    isDescriptionVisible
                        ? 'Sembunyikan Deskripsi'
                        : 'Tampilkan Deskripsi',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCover(BuildContext context, ColorScheme colorScheme) {
    Widget buildFallback() {
      if (book.imageUrl != null && book.imageUrl!.isNotEmpty) {
        return Image.network(
          book.imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: colorScheme.surfaceContainerHighest,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => _buildFallbackIcon(colorScheme),
        );
      }
      return _buildFallbackIcon(colorScheme);
    }

    Widget imageWidget;
    if (book.assetPath != null && book.assetPath!.isNotEmpty) {
      imageWidget = Image.asset(
        book.assetPath!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => buildFallback(),
      );
    } else {
      imageWidget = buildFallback();
    }

    return Container(
      width: 68,
      height: 98,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: imageWidget,
      ),
    );
  }

  Widget _buildFallbackIcon(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.secondaryContainer,
      child: Center(
        child: Icon(
          Icons.book_outlined,
          size: 30,
          color: colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}