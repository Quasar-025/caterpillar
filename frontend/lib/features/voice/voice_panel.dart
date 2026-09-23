import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import 'voice_intent.dart';
import 'voice_providers.dart';

Future<void> showVoiceAssistant(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.72),
    builder: (_) => const VoiceAssistantPanel(),
  );
}

class VoiceAssistantButton extends ConsumerWidget {
  const VoiceAssistantButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voiceAssistantProvider);
    final active = state.isListening || state.isSpeaking;
    return Semantics(
      button: true,
      label: active ? 'Open active voice assistant' : 'Open voice assistant',
      child: IconButton(
        tooltip: 'Operator voice assistant',
        onPressed: () => showVoiceAssistant(context),
        style: IconButton.styleFrom(
          minimumSize: const Size(44, 44),
          backgroundColor: active
              ? CatTheme.yellow.withValues(alpha: 0.16)
              : CatTheme.panel,
          foregroundColor: active ? CatTheme.yellow : CatTheme.textPrimary,
          side: BorderSide(color: active ? CatTheme.yellow : CatTheme.divider),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(active ? Icons.graphic_eq_rounded : Icons.mic_rounded),
      ),
    );
  }
}

class VoiceAssistantPanel extends ConsumerStatefulWidget {
  const VoiceAssistantPanel({super.key});

  @override
  ConsumerState<VoiceAssistantPanel> createState() =>
      _VoiceAssistantPanelState();
}

class _VoiceAssistantPanelState extends ConsumerState<VoiceAssistantPanel> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceAssistantProvider);
    final controller = ref.read(voiceAssistantProvider.notifier);
    final busy = state.isInitializing || state.isListening;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Material(
          color: CatTheme.panelRaised,
          clipBehavior: Clip.antiAlias,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 18 + bottomInset),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: CatTheme.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: CatTheme.yellow.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(
                            color: CatTheme.yellow.withValues(alpha: 0.5),
                          ),
                        ),
                        child: const Icon(
                          Icons.record_voice_over_rounded,
                          color: CatTheme.yellow,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Operator Assistant',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            Text(
                              'Six focused questions. Live machine facts.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close voice assistant',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _Conversation(state: state),
                  const SizedBox(height: 14),
                  _PushToTalkButton(state: state, controller: controller),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    _StatusMessage(
                      icon: Icons.info_outline_rounded,
                      text: state.errorMessage!,
                      color: CatTheme.attention,
                    ),
                  ],
                  if (state.audioMutedForSafety) ...[
                    const SizedBox(height: 12),
                    const _StatusMessage(
                      icon: Icons.volume_off_rounded,
                      text:
                          'Spoken playback is muted while a critical safety '
                          'alert is active.',
                      color: CatTheme.critical,
                    ),
                  ],
                  const SizedBox(height: 18),
                  Text(
                    'Quick questions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final intent in VoiceIntent.values)
                        _IntentChip(
                          intent: intent,
                          selected: state.answer?.intent == intent,
                          enabled: !busy,
                          onPressed: () => unawaited(controller.ask(intent)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _textController,
                    enabled: !busy,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submitTyped(controller),
                    decoration: InputDecoration(
                      labelText: 'Type a supported question',
                      hintText: "Why did my ETA change?",
                      suffixIcon: IconButton(
                        tooltip: 'Ask question',
                        onPressed: busy ? null : () => _submitTyped(controller),
                        icon: const Icon(Icons.arrow_upward_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitTyped(VoiceAssistantController controller) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    FocusScope.of(context).unfocus();
    unawaited(controller.submit(text));
  }
}

class _PushToTalkButton extends StatelessWidget {
  const _PushToTalkButton({required this.state, required this.controller});

  final VoiceAssistantState state;
  final VoiceAssistantController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: state.isInitializing
                ? null
                : state.isListening
                ? controller.stopListening
                : controller.startListening,
            style: FilledButton.styleFrom(
              backgroundColor: state.isListening
                  ? CatTheme.critical
                  : CatTheme.yellow,
              foregroundColor: CatTheme.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            icon: state.isInitializing
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: CatTheme.black,
                    ),
                  )
                : Icon(
                    state.isListening ? Icons.stop_rounded : Icons.mic_rounded,
                  ),
            label: Text(
              state.isInitializing
                  ? 'STARTING MICROPHONE'
                  : state.isListening
                  ? 'STOP AND ANSWER'
                  : 'PUSH TO TALK',
            ),
          ),
        ),
        if (state.isSpeaking)
          TextButton.icon(
            onPressed: controller.stopSpeaking,
            icon: const Icon(Icons.volume_off_rounded),
            label: const Text('Stop spoken answer'),
          ),
      ],
    );
  }
}

class _Conversation extends StatelessWidget {
  const _Conversation({required this.state});

  final VoiceAssistantState state;

  @override
  Widget build(BuildContext context) {
    final transcript = state.transcript.trim();
    final answer = state.answer;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CatTheme.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: state.isListening ? CatTheme.yellow : CatTheme.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                state.isListening
                    ? Icons.graphic_eq_rounded
                    : Icons.chat_bubble_outline_rounded,
                color: state.isListening ? CatTheme.yellow : CatTheme.textMuted,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                state.isListening ? 'LISTENING' : 'CONVERSATION',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: state.isListening
                      ? CatTheme.yellow
                      : CatTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            transcript.isEmpty
                ? 'Ask about ETA, your next task, fuel, schedule, or safety.'
                : 'YOU  $transcript',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: transcript.isEmpty
                  ? CatTheme.textMuted
                  : CatTheme.textPrimary,
            ),
          ),
          if (answer != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Text(
              'ASSISTANT  ${answer.displayText}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: CatTheme.yellow,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IntentChip extends StatelessWidget {
  const _IntentChip({
    required this.intent,
    required this.selected,
    required this.enabled,
    required this.onPressed,
  });

  final VoiceIntent intent;
  final bool selected;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(_iconFor(intent), size: 17),
      label: Text(intent.label),
      onPressed: enabled ? onPressed : null,
      backgroundColor: selected
          ? CatTheme.yellow.withValues(alpha: 0.15)
          : CatTheme.panel,
      side: BorderSide(color: selected ? CatTheme.yellow : CatTheme.divider),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

IconData _iconFor(VoiceIntent intent) {
  return switch (intent) {
    VoiceIntent.currentEta => Icons.timer_outlined,
    VoiceIntent.nextTask => Icons.next_plan_outlined,
    VoiceIntent.etaChange => Icons.troubleshoot_rounded,
    VoiceIntent.fuelRemaining => Icons.local_gas_station_outlined,
    VoiceIntent.scheduleRecovery => Icons.schedule_rounded,
    VoiceIntent.safetyStatus => Icons.shield_outlined,
  };
}
