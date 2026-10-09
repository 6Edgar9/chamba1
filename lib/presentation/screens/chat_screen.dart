import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/price_dial_stepper.dart';
import '../../data/models/job_request.dart';
import '../../data/models/chat_message.dart';
import '../state/app_state.dart';
import 'job_tracking_screen.dart';

class ChatScreen extends StatefulWidget {
  final AppState appState;
  final JobRequest job;

  const ChatScreen({
    super.key,
    required this.appState,
    required this.job,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.appState.addListener(_onStateChange);
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    widget.appState.removeListener(_onStateChange);
    super.dispose();
  }

  void _sendTextMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    widget.appState.sendChatMessage(
      jobId: widget.job.id,
      text: text,
    );
    _messageController.clear();
    _scrollToBottom();
  }

  void _showProposePriceModal() {
    double proposed = widget.job.budget;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.canvas,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.muted.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Enviar Propuesta Económica',
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Aparecerá como una tarjeta de acuerdo directo en la conversación.',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 18),
                    PriceDialStepper(
                      currentPrice: proposed,
                      minPrice: 15.0,
                      maxPrice: 1500.0,
                      label: 'Monto Propuesto en Soles',
                      onPriceChanged: (val) {
                        setModalState(() => proposed = val);
                      },
                    ),
                    const SizedBox(height: 20),
                    ChambaButton(
                      label: 'Proponer S/. ${proposed.toStringAsFixed(0)} en el Chat',
                      onPressed: () {
                        widget.appState.sendChatMessage(
                          jobId: widget.job.id,
                          text: 'Te propongo cerrar el trabajo por este monto:',
                          proposalAmount: proposed,
                        );
                        Navigator.of(context).pop();
                        _scrollToBottom();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.appState.messagesForJob(widget.job.id);
    final isClient = widget.appState.isClient;
    final partnerName = isClient
        ? (widget.job.workerName ?? 'Jorge Quispe Baldera')
        : widget.job.clientName;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: Text(
                partnerName.isNotEmpty ? partnerName[0] : 'T',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partnerName,
                    style: AppTypography.bodyLgMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'En línea • Chiclayo',
                        style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Llamando al número verificado +51 974 812 345...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.primary),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => JobTrackingScreen(
                    appState: widget.appState,
                    job: widget.job,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top sticky negotiation bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.surfaceContainerLow,
              child: Row(
                children: [
                  const Icon(Icons.handshake_outlined, size: 20, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Presupuesto actual acordado',
                          style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                        ),
                        Text(
                          'S/. ${widget.job.budget.toStringAsFixed(0)}',
                          style: AppTypography.labelLg.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ChambaButton.pill(
                    label: 'Negociar Precio',
                    onPressed: _showProposePriceModal,
                  ),
                ],
              ),
            ),

            // Messages list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = isClient ? !msg.isFromWorker : msg.isFromWorker;
                  return _buildMessageBubble(msg, isMe);
                },
              ),
            ),

            // Bottom Input bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.card,
                border: Border(
                  top: BorderSide(color: Color(0x14202D33), width: 1),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.price_change_outlined, color: AppColors.secondary),
                    tooltip: 'Proponer precio en Soles',
                    onPressed: _showProposePriceModal,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.canvas,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendTextMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: _sendTextMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe ? null : Border.all(color: const Color(0x14202D33)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08173B4D),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: AppTypography.bodyMd.copyWith(
                color: isMe ? Colors.white : AppColors.neutral,
                height: 1.35,
              ),
            ),
            if (msg.proposalAmount != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.white.withValues(alpha: 0.12)
                      : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isMe ? Colors.white24 : const Color(0x1F284B5D),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'OFERTA PROPUESTA',
                      style: AppTypography.labelSm.copyWith(
                        color: isMe ? Colors.white70 : AppColors.muted,
                        fontWeight: FontWeight.w800,
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'S/. ${msg.proposalAmount!.toStringAsFixed(0)}',
                      style: AppTypography.numericBid.copyWith(
                        color: isMe ? Colors.white : AppColors.secondary,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!isMe)
                      ChambaButton.pill(
                        label: 'Aceptar S/. ${msg.proposalAmount!.toStringAsFixed(0)}',
                        onPressed: () {
                          widget.appState.updateJobStatus(widget.job.id, JobStatus.onTheWay);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => JobTrackingScreen(
                                appState: widget.appState,
                                job: widget.job.copyWith(
                                  budget: msg.proposalAmount,
                                  status: JobStatus.onTheWay,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
              style: AppTypography.labelSm.copyWith(
                fontSize: 10,
                color: isMe ? Colors.white70 : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
