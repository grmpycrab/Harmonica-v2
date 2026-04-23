import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/entities/music_key.dart';
import '../../../presentation/viewmodels/circle_of_fifths_viewmodel.dart';

/// A single key node rendered on the Circle of Fifths.
///
/// Tap to select; colour reflects selection, relative, dominant/subdominant,
/// or default state.
class KeyNodeWidget extends StatelessWidget {
  const KeyNodeWidget({
    super.key,
    required this.musicKey,
    required this.state,
    required this.onTap,
    required this.size,
    required this.isOuter,
  });

  final MusicKey musicKey;
  final CircleOfFifthsState state;
  final VoidCallback onTap;

  /// Diameter of this node.
  final double size;

  /// True = outer ring (major), false = inner ring (minor).
  final bool isOuter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isSelected = state.isSelected(musicKey);
    final isRelative = state.isRelative(musicKey);
    final isDominant = state.isDominant(musicKey);
    final isSubdominant = state.isSubdominant(musicKey);

    final Color fill;
    final Color border;
    final Color textColor;
    final double elevation;

    if (isSelected) {
      fill = cs.primary;
      border = cs.primary;
      textColor = cs.onPrimary;
      elevation = 6;
    } else if (isRelative) {
      fill = cs.primary.withAlpha(40);
      border = cs.primary.withAlpha(180);
      textColor = cs.primary;
      elevation = 2;
    } else if (isDominant || isSubdominant) {
      fill = cs.secondaryContainer.withAlpha(120);
      border = cs.secondary.withAlpha(160);
      textColor = cs.onSecondaryContainer;
      elevation = 1;
    } else {
      fill = theme.colorScheme.surface;
      border = cs.outlineVariant;
      textColor = cs.onSurface;
      elevation = 0;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fill,
          border: Border.all(color: border, width: isSelected ? 2 : 1),
          boxShadow: elevation > 0
              ? [
                  BoxShadow(
                    color: cs.primary.withAlpha((elevation * 20).round()),
                    blurRadius: elevation * 3,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            musicKey.shortLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: isOuter ? 11 : 9.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// The full circular diagram: outer ring (major keys) + inner ring (minors).
///
/// Uses a custom [CustomPainter] for the ring lines and positions [KeyNodeWidget]s
/// via polar-to-cartesian conversion on a [Stack].
///
/// The widget fills its parent's width and sets its own height to match
/// (1:1 aspect ratio), so the caller just needs to constrain the width.
class CircleOfFifthsWidget extends StatelessWidget {
  const CircleOfFifthsWidget({
    super.key,
    required this.state,
    required this.onKeyTap,
  });

  final CircleOfFifthsState state;
  final void Function(MusicKey) onKeyTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        const outerNodeSize = 44.0;
        const innerNodeSize = 36.0;

        // totalSize fills the available width exactly.
        // outerRadius is derived so that nodes never escape the bounding box:
        //   leftmost node left-edge  = totalSize/2 - outerRadius - outerNodeSize/2 ≥ 0
        //   rightmost node right-edge = totalSize/2 + outerRadius + outerNodeSize/2 ≤ totalSize
        // ⟹ outerRadius = (totalSize - outerNodeSize) / 2
        final totalSize = constraints.maxWidth;
        final outerRadius = (totalSize - outerNodeSize) / 2;
        final innerRadius = outerRadius * 0.62;

        return SizedBox(
          width: totalSize,
          height: totalSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Ring lines ────────────────────────────────────────────
              CustomPaint(
                size: Size(totalSize, totalSize),
                painter: _RingPainter(
                  outerRadius: outerRadius,
                  innerRadius: innerRadius,
                  color: theme.colorScheme.outlineVariant.withAlpha(80),
                ),
              ),

              // ── Centre label ──────────────────────────────────────────
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.selectedKey.tonic,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    state.selectedKey.isMajor ? 'major' : 'minor',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              // ── Outer ring (major) ────────────────────────────────────
              for (int i = 0; i < state.majorKeys.length; i++)
                _placedNode(
                  index: i,
                  total: 12,
                  radius: outerRadius,
                  totalSize: totalSize,
                  nodeSize: outerNodeSize,
                  child: KeyNodeWidget(
                    musicKey: state.majorKeys[i],
                    state: state,
                    onTap: () => onKeyTap(state.majorKeys[i]),
                    size: outerNodeSize,
                    isOuter: true,
                  ),
                ),

              // ── Inner ring (minor) ────────────────────────────────────
              for (int i = 0; i < state.minorKeys.length; i++)
                _placedNode(
                  index: i,
                  total: 12,
                  radius: innerRadius,
                  totalSize: totalSize,
                  nodeSize: innerNodeSize,
                  child: KeyNodeWidget(
                    musicKey: state.minorKeys[i],
                    state: state,
                    onTap: () => onKeyTap(state.minorKeys[i]),
                    size: innerNodeSize,
                    isOuter: false,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Converts a polar position to an absolutely-placed widget on the Stack.
  Widget _placedNode({
    required int index,
    required int total,
    required double radius,
    required double totalSize,
    required double nodeSize,
    required Widget child,
  }) {
    // Start at top (-π/2), go clockwise
    final angle = (2 * math.pi * index / total) - math.pi / 2;
    final cx = totalSize / 2 + radius * math.cos(angle);
    final cy = totalSize / 2 + radius * math.sin(angle);
    return Positioned(
      left: cx - nodeSize / 2,
      top: cy - nodeSize / 2,
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Ring painter
// ---------------------------------------------------------------------------

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.outerRadius,
    required this.innerRadius,
    required this.color,
  });

  final double outerRadius;
  final double innerRadius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, outerRadius, paint);
    canvas.drawCircle(center, innerRadius, paint);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.outerRadius != outerRadius ||
      old.innerRadius != innerRadius ||
      old.color != color;
}
