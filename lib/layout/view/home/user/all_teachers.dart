import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BestTeachersCard extends StatelessWidget {
  final List<TeacherModel> teachers;

  const BestTeachersCard({super.key, required this.teachers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.h, // Increased height for better proportions
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: teachers.length,
        separatorBuilder: (_, __) => SizedBox(width: 16.w), // Increased spacing
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          return _TeacherCard(teacher: teacher);
        },
      ),
    );
  }
}

class _TeacherCard extends StatefulWidget {
  final TeacherModel teacher;

  const _TeacherCard({required this.teacher});

  @override
  State<_TeacherCard> createState() => _TeacherCardState();
}

class _TeacherCardState extends State<_TeacherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTap() {
    // Add haptic feedback
    HapticFeedback.lightImpact();
    // Navigate to detail screen
    // Get.to(() => TeacherDetailScreen(teacher: widget.teacher));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: _onTap,
            child: Container(
              width: 160.w, // Slightly wider for better proportions
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r), // Increased radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_isPressed ? 0.1 : 0.08),
                    blurRadius: _isPressed ? 12 : 16,
                    offset: Offset(0, _isPressed ? 2 : 6),
                    spreadRadius: _isPressed ? 0 : 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Enhanced Image Section
                  _buildImageSection(),
                  // Enhanced Content Section
                  _buildContentSection(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          child: CachedNetworkImage(
            imageUrl: widget.teacher.imageUrl,
            width: 160.w,
            height: 110.h, // Adjusted height
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 160.w,
              height: 110.h,
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'loading'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 160.w,
              height: 110.h,
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 32.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'no_image_available'.tr(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Online status indicator (if available)
        if (widget.teacher.isOnline ?? false)
          Positioned(
            top: 8.h,
            right: 8.w,
            child: Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Name and Subject
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.teacher.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.teacher.subject,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // Rating and additional info
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 12.sp,
                            color: Colors.amber[700],
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            widget.teacher.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.teacher.studentCount != null) ...[
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          '${widget.teacher.studentCount} ${'students'.tr()}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[500],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced TeacherModel (add these properties if not already present)
extension TeacherModelExtension on TeacherModel {
  bool? get isOnline => null; // Add this to your model
  int? get studentCount => null; // Add this to your model
}

class TeacherModel {
  final String name;
  final String imageUrl;
  final String subject;
  final double rating;

  TeacherModel({
    required this.name,
    required this.imageUrl,
    required this.subject,
    required this.rating,
  });
}
