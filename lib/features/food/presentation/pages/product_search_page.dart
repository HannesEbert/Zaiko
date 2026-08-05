import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/food_providers.dart';
import '../../domain/food.dart';
import '../../domain/food_failure.dart';
import '../food_error_message.dart';

/// Full-screen Open Food Facts product search for the add flow. Picking a
/// result caches it in the shared catalog and pops with the stored [Food], so
/// the add form can pre-fill from it and link `food_id`.
class ProductSearchPage extends ConsumerStatefulWidget {
  const ProductSearchPage({super.key});

  /// Pushes the search page and resolves to the chosen [Food], or null when the
  /// user backs out.
  static Future<Food?> open(BuildContext context) {
    return Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute<Food>(builder: (_) => const ProductSearchPage()));
  }

  @override
  ConsumerState<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends ConsumerState<ProductSearchPage> {
  final _controller = TextEditingController();
  Timer? _debounce;

  bool _loading = false;
  Object? _error;
  List<Food> _results = const [];

  /// Wait for typing to settle before hitting the network, to respect the
  /// Open Food Facts API and avoid a request per keystroke.
  static const Duration _debounceDelay = Duration(milliseconds: 350);

  /// A single letter is effectively a wildcard: it floods the (slow) endpoint
  /// and surfaces popular imports, so only search from this length on.
  static const int _minQueryLength = 2;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.length < _minQueryLength) {
      setState(() {
        _loading = false;
        _error = null;
        _results = const [];
      });
      return;
    }
    _debounce = Timer(_debounceDelay, () => _search(query));
  }

  Future<void> _search(String query) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await ref
          .read(productResolverProvider.notifier)
          .search(query);
      // A newer keystroke may have superseded this search while it was in
      // flight; only the latest query's results should win.
      if (!mounted || _controller.text.trim() != query) return;
      setState(() {
        _loading = false;
        _results = results;
      });
    } on FoodFailure catch (e) {
      if (!mounted || _controller.text.trim() != query) return;
      setState(() {
        _loading = false;
        _error = e;
      });
    }
  }

  Future<void> _select(Food product) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      final cached = await ref
          .read(productResolverProvider.notifier)
          .selectSearchResult(product);
      if (!mounted) return;
      Navigator.of(context).pop(cached);
    } on FoodFailure catch (e) {
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(foodErrorMessage(l10n, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.productSearchTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pageInset),
              child: TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: _onQueryChanged,
                style: AppTypography.body.copyWith(color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: l10n.productSearchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _CenteredHint(text: foodErrorMessage(context.l10n, _error));
    }
    if (_controller.text.trim().length < _minQueryLength) {
      return _CenteredHint(text: context.l10n.productSearchPrompt);
    }
    if (_results.isEmpty) {
      return _CenteredHint(text: context.l10n.productSearchEmpty);
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageInset),
      itemCount: _results.length,
      itemBuilder: (context, index) => _ResultTile(
        food: _results[index],
        onTap: () => _select(_results[index]),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.food, required this.onTap});

  final Food food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: _Thumbnail(imageUrl: food.imageUrl),
      title: Text(
        food.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
      ),
      subtitle: food.brand == null
          ? null
          : Text(
              food.brand!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
      onTap: onTap,
    );
  }
}

/// A product thumbnail from the Open Food Facts CDN, falling back to a neutral
/// placeholder when there is no image or it fails to load.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final placeholder = Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colors.sunken,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(
        Icons.inventory_2_outlined,
        size: 20,
        color: colors.textTertiary,
      ),
    );
    final url = imageUrl;
    if (url == null) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Image.network(
        url,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}

class _CenteredHint extends StatelessWidget {
  const _CenteredHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pageInset),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
