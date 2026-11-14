/// Account / report / appeal statuses for chat moderation.
enum AccountStatus {
  active,
  suspended,
  underReview,
  unknown;

  static AccountStatus parse(String? raw) {
    switch ((raw ?? '').toLowerCase()) {
      case 'active':
        return AccountStatus.active;
      case 'suspended':
        return AccountStatus.suspended;
      case 'under_review':
        return AccountStatus.underReview;
      default:
        return AccountStatus.unknown;
    }
  }

  bool get isBlocked =>
      this == AccountStatus.suspended || this == AccountStatus.underReview;
}

class ReportReason {
  final String code;
  final String label;
  const ReportReason(this.code, this.label);

  static const all = [
    ReportReason('harassment', 'Harassment or bullying'),
    ReportReason('offensive', 'Hate speech or abuse'),
    ReportReason('threatening', 'Threats or violence'),
    ReportReason('inappropriate', 'Sexual or inappropriate content'),
    ReportReason('spam', 'Spam or scams'),
    ReportReason('other', 'Something else'),
  ];

  static ReportReason? byCode(String code) {
    for (final r in all) {
      if (r.code == code) return r;
    }
    return null;
  }
}

class ModerationStatus {
  final AccountStatus accountStatus;
  final String? suspensionReason;
  final DateTime? suspendedAt;
  final String? suspensionId;
  final String? appealId;
  final String? appealStatus;
  final DateTime? appealSubmittedAt;

  const ModerationStatus({
    required this.accountStatus,
    this.suspensionReason,
    this.suspendedAt,
    this.suspensionId,
    this.appealId,
    this.appealStatus,
    this.appealSubmittedAt,
  });

  bool get isBlocked => accountStatus.isBlocked;
  bool get hasActiveAppeal =>
      appealId != null &&
      (appealStatus == 'pending' || appealStatus == 'under_review');
  bool get canSubmitAppeal =>
      accountStatus == AccountStatus.suspended && !hasActiveAppeal;

  factory ModerationStatus.active() =>
      const ModerationStatus(accountStatus: AccountStatus.active);

  factory ModerationStatus.fromJson(Map<String, dynamic> json) {
    return ModerationStatus(
      accountStatus: AccountStatus.parse('${json['account_status']}'),
      suspensionReason: json['suspension_reason'] as String?,
      suspendedAt: DateTime.tryParse('${json['suspended_at'] ?? ''}'),
      suspensionId: json['suspension_id']?.toString(),
      appealId: json['appeal_id']?.toString(),
      appealStatus: json['appeal_status']?.toString(),
      appealSubmittedAt:
          DateTime.tryParse('${json['appeal_submitted_at'] ?? ''}'),
    );
  }
}

class GameReportDraft {
  final String roomId;
  final String reasonCode;
  final String description;
  final String screenshotPath;

  const GameReportDraft({
    required this.roomId,
    required this.reasonCode,
    required this.description,
    required this.screenshotPath,
  });
}
