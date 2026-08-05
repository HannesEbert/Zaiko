import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/food_providers.dart';
import '../../domain/food.dart';
import '../../domain/food_failure.dart';

/// The result of a barcode scan handed back to the add flow.
///
/// [product] is the resolved (and cached) catalog entry on a hit; it is null on
/// a miss or a lookup error, in which case [failure] carries the error (null
/// means simply not found) and the caller falls back to manual entry with
/// [barcode] pre-filled.
class ScanOutcome {
  const ScanOutcome({required this.barcode, this.product, this.failure});

  final String barcode;
  final Food? product;
  final FoodFailure? failure;
}

/// Full-screen camera barcode scanner for the add flow. Resolves the scanned
/// code against Open Food Facts in place (showing a lookup overlay) and pops
/// with a [ScanOutcome].
///
/// Camera access is requested through `permission_handler`; a denial shows an
/// explainer with a shortcut to system settings rather than a dead camera view.
class BarcodeScannerPage extends ConsumerStatefulWidget {
  const BarcodeScannerPage({super.key});

  /// Pushes the scanner and resolves to the [ScanOutcome], or null if the user
  /// backed out without scanning.
  static Future<ScanOutcome?> open(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<ScanOutcome>(
        builder: (_) => const BarcodeScannerPage(),
      ),
    );
  }

  @override
  ConsumerState<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends ConsumerState<BarcodeScannerPage> {
  MobileScannerController? _controller;
  PermissionStatus? _permission;
  bool _resolving = false;
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    setState(() {
      _permission = status;
      if (status.isGranted) {
        _controller = MobileScannerController(
          formats: const [
            BarcodeFormat.ean13,
            BarcodeFormat.ean8,
            BarcodeFormat.upcA,
            BarcodeFormat.upcE,
          ],
          detectionSpeed: DetectionSpeed.normal,
        );
      }
    });
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handled || capture.barcodes.isEmpty) return;
    final code = capture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    _handled = true;
    setState(() => _resolving = true);
    await _controller?.stop();

    final resolver = ref.read(productResolverProvider.notifier);
    ScanOutcome outcome;
    try {
      final product = await resolver.resolveByBarcode(code);
      outcome = ScanOutcome(barcode: code, product: product);
    } on FoodFailure catch (e) {
      outcome = ScanOutcome(barcode: code, failure: e);
    }
    if (!mounted) return;
    Navigator.of(context).pop(outcome);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: switch (_permission) {
          null => const Center(child: CircularProgressIndicator()),
          final status when status.isGranted && controller != null =>
            _ScannerView(
              controller: controller,
              resolving: _resolving,
              onDetect: _onDetect,
              onClose: () => Navigator.of(context).pop(),
            ),
          _ => _PermissionDenied(onClose: () => Navigator.of(context).pop()),
        },
      ),
    );
  }
}

/// The live camera preview with a scan-window cutout, controls and — while a
/// scanned code is being looked up — a resolving overlay.
class _ScannerView extends StatelessWidget {
  const _ScannerView({
    required this.controller,
    required this.resolving,
    required this.onDetect,
    required this.onClose,
  });

  final MobileScannerController controller;
  final bool resolving;
  final void Function(BarcodeCapture) onDetect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(controller: controller, onDetect: onDetect),
        const _ScanWindow(),
        Positioned(
          top: AppSpacing.s2,
          left: AppSpacing.s2,
          right: AppSpacing.s2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleButton(icon: Icons.close, onTap: onClose),
              Text(
                l10n.scannerTitle,
                style: AppTypography.headline.copyWith(color: Colors.white),
              ),
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, state, _) => _CircleButton(
                  icon: state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                  onTap: controller.toggleTorch,
                  tooltip: l10n.scannerTorchTooltip,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: AppSpacing.s5,
          right: AppSpacing.s5,
          bottom: AppSpacing.s8,
          child: Text(
            l10n.scannerHint,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: Colors.white70),
          ),
        ),
        if (resolving) _ResolvingOverlay(label: l10n.scannerResolving),
      ],
    );
  }
}

/// A dimmed backdrop with a transparent rounded rectangle marking where to aim.
class _ScanWindow extends StatelessWidget {
  const _ScanWindow();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}

class _ResolvingOverlay extends StatelessWidget {
  const _ResolvingOverlay({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.s4),
            Text(
              label,
              style: AppTypography.body.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when camera permission was denied: explains why access is needed and
/// links to system settings (the only place a permanent denial can be undone).
class _PermissionDenied extends StatelessWidget {
  const _PermissionDenied({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pageInset),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _CircleButton(icon: Icons.close, onTap: onClose),
          ),
          const Spacer(),
          Icon(
            Icons.no_photography_outlined,
            size: 48,
            color: colors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            l10n.scannerPermissionTitle,
            textAlign: TextAlign.center,
            style: AppTypography.title.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            l10n.scannerPermissionBody,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.s6),
          FilledButton(
            onPressed: openAppSettings,
            child: Text(l10n.scannerOpenSettings),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap, this.tooltip});

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black45,
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }
}
