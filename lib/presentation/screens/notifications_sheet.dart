import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../data/models/job_request.dart';
import '../state/app_state.dart';
import 'job_tracking_screen.dart';
import 'received_bids_screen.dart';

class NotificationsSheet extends StatelessWidget {
  final AppState appState;

  const NotificationsSheet({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final notifications = appState.notifications;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0x33202D33),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Notificaciones',
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (appState.unreadNotificationsCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${appState.unreadNotificationsCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    appState.markAllNotificationsAsRead();
                  },
                  child: Text(
                    'Marcar leídas',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x14202D33)),

          // List
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Text(
                      'No tienes notificaciones pendientes',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, indent: 64, color: Color(0x0F202D33)),
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return ListTile(
                        onTap: () {
                          appState.markNotificationAsRead(item.id);
                          if (item.relatedJobId != null) {
                            final job = appState.jobs.firstWhere(
                              (j) => j.id == item.relatedJobId,
                              orElse: () => appState.jobs.first,
                            );
                            Navigator.of(context).pop();
                            if (job.status == JobStatus.onTheWay ||
                                job.status == JobStatus.inProgress ||
                                job.status == JobStatus.completed) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => JobTrackingScreen(appState: appState, job: job),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ReceivedBidsScreen(appState: appState, job: job),
                                ),
                              );
                            }
                          }
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: item.isRead
                                ? AppColors.surfaceContainer
                                : AppColors.secondary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.icon,
                            color: item.isRead ? AppColors.muted : AppColors.secondary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: AppTypography.bodyLgMedium.copyWith(
                            fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                            color: AppColors.neutral,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            item.body,
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.muted,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ChambaButton(
              label: 'Cerrar',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
