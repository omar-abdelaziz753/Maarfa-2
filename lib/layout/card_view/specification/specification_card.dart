import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/widget/image_handler/image_from_network/network_image.dart';

import '../../../model/common/courses/course_details/course_details_model.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../activity/user_screens/specification/specification_screen.dart';

class SpecificationCard extends StatefulWidget {
  final Specialization specializationsModel;
  final VoidCallback? onTap;
  final bool isEnabled;
  final EdgeInsets? margin;
  final String? heroTag;

  const SpecificationCard({
    super.key,
    required this.specializationsModel,
    this.onTap,
    this.isEnabled = true,
    this.margin,
    this.heroTag,
  });

  @override
  State<SpecificationCard> createState() => _SpecificationCardState();
}

class _SpecificationCardState extends State<SpecificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTap() {
    if (!widget.isEnabled) return;

    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      Get.to(
            () => SpecificationScreen(
          title: widget.specializationsModel.name!,
          id: widget.specializationsModel.id,
        ),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  void _handleHover(bool hovering) {
    if (!widget.isEnabled) return;
    setState(() => _isHovered = hovering);
    if (hovering) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _handleFocusChange(bool focused) {
    setState(() => _isFocused = focused);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardWidth = (screenWidth - 80.w) / 2;

    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      child: Semantics(
        label: 'Specialization: ${widget.specializationsModel.name}',
        hint: 'Tap to view details',
        button: true,
        enabled: widget.isEnabled,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? _scaleAnimation.value : 1.0,
              child: Material(
                color: Colors.transparent,
                elevation: _isHovered ? _elevationAnimation.value : 2.0,
                borderRadius: BorderRadius.circular(12.r),
                shadowColor: theme.shadowColor.withValues(alpha:0.1),
                child: InkWell(
                  onTap: _handleTap,
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  onHover: _handleHover,
                  onFocusChange: _handleFocusChange,
                  borderRadius: BorderRadius.circular(12.r),
                  splashColor: theme.primaryColor.withValues(alpha:0.1),
                  highlightColor: theme.primaryColor.withValues(alpha:0.05),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 88.h,
                    width: cardWidth,
                    decoration: _buildCardDecoration(theme),
                    child: _buildCardContent(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration(ThemeData theme) {
    return BoxDecoration(
      color: widget.isEnabled ? courseTypeColor : courseTypeColor.withValues(alpha:0.5),
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: _isFocused
            ? theme.primaryColor.withValues(alpha:0.8)
            : _isHovered
            ? theme.primaryColor.withValues(alpha:0.3)
            : textfieldColor.withValues(alpha:0.3),
        width: _isFocused ? 2.0 : 1.0,
      ),
      gradient: _isHovered ? LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          courseTypeColor,
          courseTypeColor.withValues(alpha:0.95),
        ],
      ) : null,
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          _buildImageSection(),
          SizedBox(width: 12.w),
          Expanded(child: _buildTextSection()),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 64.w,
        height: 64.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: CachedImage(
          imageUrl: widget.specializationsModel.image ?? "",
          width: 64.w,
          height: 64.h,
          fit: BoxFit.cover,
        ),
      ),
    );

    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: imageWidget,
      );
    }

    return AnimatedScale(
      scale: _isHovered && widget.isEnabled ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: imageWidget,
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 24.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading...',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 24.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 2.h),
          Text(
            'No Image',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyles.hintStyle.copyWith(
              color: widget.isEnabled
                  ? (_isHovered ? Colors.black87 : grey)
                  : grey.withValues(alpha:0.5),
              fontSize: 13.sp,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
              height: 1.3,
            ),
            child: Text(
              widget.specializationsModel.name ?? "Untitled Specialization",
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // Optional: Add a subtle indicator for interactivity
        if (_isHovered && widget.isEnabled) ...[
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(
                'View Details',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 2.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 10.sp,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// Extension for better accessibility and error handling
extension SpecializationCardUtils on SpecificationCard {
  static Widget buildLoadingShimmer() {
    return Container(
      height: 88.h,
      width: (screenWidth - 80.w) / 2,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Shimmer image placeholder
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 12.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(6.r),
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
}

// Usage example with grid layout
class SpecializationGrid extends StatelessWidget {
  final List<Specialization> specializations;
  final bool isLoading;

  const SpecializationGrid({
    super.key,
    required this.specializations,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 6, // Show 6 shimmer placeholders
        itemBuilder: (context, index) {
          return SpecializationCardUtils.buildLoadingShimmer();
        },
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: specializations.length,
      itemBuilder: (context, index) {
        return SpecificationCard(
          specializationsModel: specializations[index],
          heroTag: 'specialization_${specializations[index].id}',
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:my_academy/widget/image_handler/image_from_network/network_image.dart';
//
// import '../../../models/common/courses/course_details/course_details_model.dart';
// import '../../../res/value/color/color.dart';
// import '../../../res/value/dimenssion/dimenssions.dart';
// import '../../../res/value/style/textstyles.dart';
// import '../../../widget/side_padding/side_padding.dart';
// import '../../activity/user_screens/specification/specification_screen.dart';
//
// class SpecificationCard extends StatelessWidget {
//   final Specialization specializationsModel;
//
//   const SpecificationCard({
//     super.key,
//     required this.specializationsModel,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => Get.to(() => SpecificationScreen(
//           title: specializationsModel.name!, id: specializationsModel.id)),
//       child: Card(
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         semanticContainer: true,
//         shape: RoundedRectangleBorder(
//             side: const BorderSide(color: textfieldColor),
//             borderRadius: BorderRadius.circular(5.r)),
//         child: Container(
//           height: 80.h,
//           width: (screenWidth - 80.w) / 2,
//           color: courseTypeColor,
//           child: SidePadding(
//               sidePadding: 5,
//               child: Row(
//                 children: [
//                   Card(
//                       semanticContainer: true,
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5.r),
//                       ),
//                       child: CachedImage(
//                         imageUrl: specializationsModel.image ?? "",
//                         width: 60.w,
//                         height: 75.h,
//                         fit: BoxFit.cover,
//                       )),
//                   SizedBox(
//                     width: 75.w,
//                     child: Text(
//                       specializationsModel.name ?? "",
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                       style: TextStyles.hintStyle.copyWith(color: grey),
//                     ),
//                   ),
//                 ],
//               )),
//         ),
//       ),
//     );
//   }
// }
