import 'package:flutter/material.dart';
import 'package:test_technique/core/theme/app_theme.dart';

/// Effet shimmer / skeleton pour le chargement
class ShimmerLoading extends StatefulWidget {
  final int itemCount;

  const ShimmerLoading({super.key, this.itemCount = 8});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.itemCount,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            return _ShimmerCard(gradientPosition: _animation.value);
          },
        );
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final double gradientPosition;

  const _ShimmerCard({required this.gradientPosition});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.cardColor,
        border: Border.all(
          color: AppTheme.accentCyan.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar placeholder
          _shimmerBox(48, 48, isCircle: true),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(double.infinity, 14),
                const SizedBox(height: 8),
                _shimmerBox(80, 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox(double width, double height, {bool isCircle = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: isCircle ? null : BorderRadius.circular(8),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        gradient: LinearGradient(
          begin: Alignment(gradientPosition - 1, 0),
          end: Alignment(gradientPosition + 1, 0),
          colors: [
            AppTheme.cardColor,
            AppTheme.cardColor.withValues(alpha: 0.5),
            AppTheme.cardColor,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
