import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_vibrate/flutter_vibrate.dart';

class VoiceAssistantBottomSheet extends StatefulWidget {
  final stt.SpeechToText speech;
  final Future<void> Function(String text) onResult;

  const VoiceAssistantBottomSheet({
    super.key,
    required this.speech,
    required this.onResult,
  });

  @override
  State<VoiceAssistantBottomSheet> createState() =>
      _VoiceAssistantBottomSheetState();
}

class _VoiceAssistantBottomSheetState extends State<VoiceAssistantBottomSheet>
    with SingleTickerProviderStateMixin {
  bool showConfirmation = false;
  bool isListening = false;
  bool isProcessing = false;

  String spokenText = "";
  String statusText = "Listening...";
  String detectedCategory = "";
  String detectedAmount = "";
  String detectedType = "";

  Color statusColor = Colors.black;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.92,
      upperBound: 1.05,
    )..repeat(reverse: true);

    startListening();
  }

  Future<void> startListening() async {
    bool available = await widget.speech.initialize(
      onError: (error) {
        if (!mounted) return;

        setState(() {
          statusText = "Microphone error occurred";
          statusColor = Colors.red;
        });
      },
    );

    if (!available) {
      if (!mounted) return;

      setState(() {
        statusText = "Microphone access denied";
        statusColor = Colors.red;
      });

      return;
    }

    if (!mounted) return;

    setState(() {
      isListening = true;
    });
    Vibrate.feedback(FeedbackType.light);

    // NO VOICE DETECTION
    Future.delayed(const Duration(seconds: 7), () {
      if (!mounted) return;

      if (spokenText.trim().isEmpty && !isProcessing) {
        widget.speech.stop();

        setState(() {
          statusText = "No voice detected";
          statusColor = Colors.orange;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      }
    });

    widget.speech.listen(
      listenFor: const Duration(seconds: 7),
      pauseFor: const Duration(seconds: 2),
      listenMode: stt.ListenMode.confirmation,
      onResult: (result) async {
        if (!mounted) return;

        setState(() {
          spokenText = result.recognizedWords;
        });
        final liveText = result.recognizedWords.toLowerCase();

        String liveCategory = "";
        String liveType = "Expense";

        if (liveText.contains("food")) {
          liveCategory = "Food";
        } else if (liveText.contains("uber") ||
            liveText.contains("cab") ||
            liveText.contains("taxi")) {
          liveCategory = "Travel";
        } else if (liveText.contains("netflix")) {
          liveCategory = "Entertainment";
        } else if (liveText.contains("salary")) {
          liveCategory = "Salary";
          liveType = "Income";
        }

        final amountMatch = RegExp(r'\d+').firstMatch(result.recognizedWords);

        String liveAmount = "";

        if (amountMatch != null) {
          liveAmount = "₹${amountMatch.group(0)}";
        }

        setState(() {
          detectedCategory = liveCategory;
          detectedAmount = liveAmount;
          detectedType = liveType;
        });

        // LIVE GARBAGE DETECTION
        final lowerLiveText = result.recognizedWords.toLowerCase();

        bool looksValid =
            lowerLiveText.contains("food") ||
            lowerLiveText.contains("salary") ||
            lowerLiveText.contains("uber") ||
            lowerLiveText.contains("netflix") ||
            RegExp(r'\d+').hasMatch(result.recognizedWords);

        if (!looksValid && result.finalResult) {
          setState(() {
            statusText = "Couldn't understand transaction";
            statusColor = Colors.red;
          });
          Vibrate.feedback(FeedbackType.error);
        }

        if (result.finalResult) {
          final lowerText = result.recognizedWords.toLowerCase();

          bool validCategory =
              lowerText.contains("food") ||
              lowerText.contains("salary") ||
              lowerText.contains("uber") ||
              lowerText.contains("netflix");

          bool hasAmount = RegExp(r'\d+').hasMatch(result.recognizedWords);

          // GARBAGE SPEECH
          if (!validCategory) {
            if (!mounted) return;

            setState(() {
              statusText = "Couldn't understand transaction";
              statusColor = Colors.red;
            });
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted && Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });

            return;
          }

          // NO AMOUNT
          if (!hasAmount) {
            if (!mounted) return;

            setState(() {
              statusText = "Amount not detected";
              statusColor = Colors.orange;
            });
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted && Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });

            return;
          }

          // PROCESSING STATE
          if (!mounted) return;

          
          setState(() {
            showConfirmation = true;
            isListening = false;
            widget.speech.stop();

            statusText = "Review transaction";
            statusColor = Colors.blue;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(38)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              "Voice Assistant",
              style: GoogleFonts.manrope(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: const Color(0xff0F172A),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              statusText,
              style: GoogleFonts.inter(
                color: statusColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 40),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),

              child:
                  isProcessing
                      ? Container(
                        key: const ValueKey("loading"),

                        height: 120,
                        width: 120,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: const RadialGradient(
                            colors: [Color(0xff1E293B), Color(0xff0F172A)],
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff6366F1).withOpacity(0.35),

                              blurRadius: 35,
                              spreadRadius: 8,
                            ),
                          ],
                        ),

                        child: const Padding(
                          padding: EdgeInsets.all(34),

                          child: CircularProgressIndicator(
                            strokeWidth: 3,

                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      )
                      : AnimatedBuilder(
                        key: const ValueKey("orb"),
                        animation: _controller,

                        builder: (context, child) {
                          return Transform.scale(
                            scale: _controller.value,

                            child: Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,

                                  colors: [
                                    Color(0xff1E293B),
                                    Color(0xff0F172A),
                                    Color(0xff020617),
                                  ],
                                ),

                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                  width: 1.4,
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xff3B82F6,
                                    ).withOpacity(0.18),

                                    blurRadius: 40,
                                    spreadRadius: 4,
                                  ),

                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.22),

                                    blurRadius: 30,
                                    offset: const Offset(0, 16),
                                  ),
                                ],
                              ),

                              child: Center(
                                child: Container(
                                  height: 52,
                                  width: 52,

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,

                                    color: Colors.white.withOpacity(0.12),
                                  ),

                                  child: const Icon(
                                    Icons.multitrack_audio_rounded,

                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),

            const SizedBox(height: 42),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xffF8FAFC),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.graphic_eq_rounded,
                        color: Color(0xff0F172A),
                        size: 20,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        "Live Transcript",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: const Color(0xff0F172A),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    spokenText.isEmpty ? "Start speaking..." : spokenText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.4,
                      color: const Color(0xff0F172A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (detectedCategory.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xffF8FAFC),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      "Detected Transaction",
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.category),
                            const SizedBox(height: 6),
                            Text(detectedCategory),
                          ],
                        ),

                        Column(
                          children: [
                            const Icon(Icons.currency_rupee),
                            const SizedBox(height: 6),
                            Text(detectedAmount),
                          ],
                        ),

                        Column(
                          children: [
                            const Icon(Icons.swap_horiz),
                            const SizedBox(height: 6),
                            Text(detectedType),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            if (showConfirmation)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xffF8FAFC),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: Colors.green.withOpacity(0.15)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green.shade600,
                      size: 42,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Confirm Transaction",
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "$detectedCategory • $detectedAmount",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                isProcessing = true;
                                statusText = "Saving transaction...";
                                statusColor = Colors.blue;
                              });

                              await widget.onResult(spokenText);

                              if (!mounted) return;

                              setState(() {
                                isProcessing = false;
                                statusText = "Transaction added";
                                statusColor = Colors.green;
                              });
                              Vibrate.feedback(FeedbackType.success);

                              Future.delayed(const Duration(seconds: 2), () {
                                if (mounted && Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              });
                            },

                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff0F172A),
                                    Color(0xff1E293B),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Text(
                                  "Confirm",
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xffF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Try: "Spent 500 on food"',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
