import 'package:flutter/material.dart';
import '../theme.dart';

/// Shared PDF-matching UI primitives (Public Profile / Friends / Challenge).

const pdfAvatarGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFE85A8C), Color(0xFFFF9A4A)],
);

class PdfGradientAvatar extends StatelessWidget {
  final String letter;
  final double size;
  const PdfGradientAvatar(this.letter, {super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final ch = letter.trim().isEmpty ? '?' : letter.trim()[0].toUpperCase();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: pdfAvatarGradient,
      ),
      child: Text(
        ch,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.42,
        ),
      ),
    );
  }
}

class PdfSegRow extends StatelessWidget {
  final List<String> options;
  final int selected;
  final ValueChanged<int> onChanged;
  const PdfSegRow({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.border2),
      ),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == selected ? C.magenta : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    options[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: i == selected ? Colors.white : C.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PdfSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onSubmitted;
  const PdfSearchField({
    super.key,
    required this.controller,
    this.hint = 'Search by username or ID',
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.teal, width: 1.4),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: C.text, fontSize: 15),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: C.muted, fontSize: 15),
          isDense: true,
        ),
      ),
    );
  }
}

class PdfTealButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool compact;
  const PdfTealButton(this.label,
      {super.key, this.onTap, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 40 : 54,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: C.teal,
          foregroundColor: const Color(0xFF04201F),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: compact ? 13 : 15,
          ),
        ),
      ),
    );
  }
}

class PdfPinkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const PdfPinkButton(this.label, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: C.magenta,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    );
  }
}

class PdfOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color borderColor;
  final Color textColor;
  const PdfOutlineButton(
    this.label, {
    super.key,
    this.onTap,
    this.borderColor = C.border2,
    this.textColor = C.muted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textColor),
        ),
      ),
    );
  }
}

class PdfDeclineBox extends StatelessWidget {
  final VoidCallback? onTap;
  const PdfDeclineBox({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.border2),
        ),
        child: const Icon(Icons.close, color: C.text, size: 20),
      ),
    );
  }
}

class PdfSectionLabel extends StatelessWidget {
  final String text;
  const PdfSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: C.teal,
        fontSize: 11,
        letterSpacing: 2.2,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class PdfCoinChip extends StatelessWidget {
  final int value;
  const PdfCoinChip(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: C.border2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.diamond, size: 16, color: C.teal),
          const SizedBox(width: 6),
          Text(
            '$value',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class PdfModalCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final EdgeInsets padding;
  const PdfModalCard({
    super.key,
    required this.child,
    this.borderColor = C.magenta,
    this.padding = const EdgeInsets.fromLTRB(20, 22, 20, 20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 1.6),
      ),
      child: child,
    );
  }
}

class PdfCircularTimer extends StatelessWidget {
  final int value;
  final int total;
  final double size;
  const PdfCircularTimer({
    super.key,
    required this.value,
    this.total = 60,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final p = total <= 0 ? 0.0 : (value / total).clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: p,
              strokeWidth: 8,
              backgroundColor: C.surface2,
              color: C.magenta,
            ),
          ),
          Text(
            '$value',
            style: TextStyle(
              fontSize: size * 0.32,
              fontWeight: FontWeight.w900,
              color: C.text,
            ),
          ),
        ],
      ),
    );
  }
}

class PdfGhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const PdfGhostButton(this.label, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: C.text,
          side: const BorderSide(color: C.border2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
    );
  }
}

class PdfQuickChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const PdfQuickChip(this.label, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: C.surface2,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: C.border2),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}
