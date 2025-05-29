import 'package:flutter/material.dart';

class CustomTooltip extends StatefulWidget {
  final Widget child;
  final Widget tooltipContent;

  const CustomTooltip({
    Key? key,
    required this.child,
    required this.tooltipContent,
  }) : super(key: key);

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Adjust positioning if needed
    double tooltipLeft = offset.dx;
    double tooltipTop = offset.dy + renderBox.size.height + 8;

    // Prevent overflow on the right
    if (tooltipLeft + 600 > MediaQuery.of(context).size.width) {
      tooltipLeft =
          MediaQuery.of(context).size.width - 600 - 20; // 20 for padding
    }
    if (tooltipLeft < 0) {
      // Prevent overflow on the left
      tooltipLeft = 20;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: tooltipLeft,
        top: tooltipTop,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 600, // Atur sesuai kebutuhan
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black87, // Dark background
              borderRadius: BorderRadius.circular(16),
            ),
            child: widget.tooltipContent,
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showOverlay(context),
      onExit: (_) => _hideOverlay(),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _hideOverlay(); // Ensure overlay is removed when widget is disposed
    super.dispose();
  }
}
