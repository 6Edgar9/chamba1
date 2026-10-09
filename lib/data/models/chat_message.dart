class ChatMessage {
  final String id;
  final String jobId;
  final String senderId;
  final String senderName;
  final bool isFromWorker;
  final String text;
  final double? proposalAmount; // For in-chat counter-offers S/.
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.jobId,
    required this.senderId,
    required this.senderName,
    required this.isFromWorker,
    required this.text,
    this.proposalAmount,
    required this.timestamp,
  });
}
