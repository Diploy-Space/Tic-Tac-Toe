import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';

/// Compact offline strip for Home. Hidden while online / checking.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppConnectivity>(
      valueListenable: ConnectivityService.instance.status,
      builder: (_, status, __) {
        if (status != AppConnectivity.offline) {
          return const SizedBox.shrink();
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: C.border2),
          ),
          child: Row(
            children: [
              const Icon(Icons.wifi_off, size: 18, color: C.danger),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.l10n.offlineBanner,
                  style: const TextStyle(
                    color: C.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
