// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:my_academy/layout/view/home/user/data/cubit/home_state.dart';
// import 'package:my_academy/layout/view/home/user/view_all_teachers.dart';
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_academy/layout/view/home/user/data/cubit/home_state.dart';
import 'package:my_academy/layout/view/home/user/view_all_teachers.dart';

import 'data/cubit/home_cubit.dart';
import 'data/models/get_all_specializations_data_model.dart';

class ViewAllSpecializationScreen extends StatefulWidget {
  const ViewAllSpecializationScreen({super.key});

  @override
  State<ViewAllSpecializationScreen> createState() => _ViewAllSpecializationScreenState();
}

class _ViewAllSpecializationScreenState extends State<ViewAllSpecializationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<Home2Cubit>().getAllSpecializations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'specializations'.tr(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<Home2Cubit, Home2State>(
        builder: (context, state) {
          // if (state is GetAllSpecializationsLoadingState) {
          //   return _buildLoadingState();
          // } else
          //   if (state is GetAllSpecializationsErrorState) {
          //   return _buildErrorState(state.errorMessage);
          // } else if (state is GetAllSpecializationsSuccessState) {
          //   final specializations = context.read<HomeCubit>().allSpecializations;
          //   if (specializations.isEmpty) {
          //     return _buildEmptyState();
          //   }
          //   return _buildSpecializationsGrid(specializations);
          // }
          // return _buildLoadingState();
         return state is GetAllSpecializationsLoadingState
              ? const Center(child: CircularProgressIndicator())
              : state is GetAllSpecializationsErrorState
                  ? _buildErrorState(state.errorMessage)
                  : state is GetAllSpecializationsSuccessState
                      ? _buildSpecializationsGrid(context.read<Home2Cubit>().allSpecializations)
                      : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // Widget _buildLoadingState() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const CircularProgressIndicator(),
  //         SizedBox(height: 16.h),
  //         Text(
  //           'loading_specializations'.tr(),
  //           style: TextStyle(fontSize: 16.sp),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, size: 48.w, color: Colors.red),
            ),
            SizedBox(height: 24.h),
            Text(
              'oops_something_went_wrong'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.read<Home2Cubit>().getAllSpecializations(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text('try_again'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.school_outlined, size: 48.w, color: Colors.black54),
            ),
            SizedBox(height: 24.h),
            Text(
              'no_specializations_found'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'specializations_will_appear_here'.tr(),
              style: TextStyle(color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSpecializationsGrid(List<SpecializationData> specializations) {
  //   return RefreshIndicator(
  //     onRefresh: () async {
  //       context.read<HomeCubit>().getAllSpecializations();
  //     },
  //     child: CustomScrollView(
  //       slivers: [
  //         SliverPadding(
  //           padding: EdgeInsets.all(16.w),
  //           sliver: SliverToBoxAdapter(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text('choose_specialization'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
  //                 SizedBox(height: 8.h),
  //                 Text('find_best_teachers_in_field'.tr(), style: TextStyle(color: Colors.black87)),
  //                 SizedBox(height: 24.h),
  //               ],
  //             ),
  //           ),
  //         ),
  //         SliverPadding(
  //           padding: EdgeInsets.symmetric(horizontal: 16.w),
  //           sliver: SliverGrid(
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2,
  //               childAspectRatio: 0.85,
  //               crossAxisSpacing: 16.w,
  //               mainAxisSpacing: 16.h,
  //             ),
  //             delegate: SliverChildBuilderDelegate(
  //                   (context, index) {
  //                 return _buildSpecializationCard(specializations[index]);
  //               },
  //               childCount: specializations.length,
  //             ),
  //           ),
  //         ),
  //         SliverToBoxAdapter(child: SizedBox(height: 24.h)),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildSpecializationCard(SpecializationData specialization) {
  //   return GestureDetector(
  //
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => ViewAllTeachers(
  //             selectedSpecializationId: specialization.id!,
  //             specializationName: specialization.name ?? 'Teachers',
  //           ),
  //         ),
  //       );
  //     },
  //     // onTap: () => _onSpecializationTap(specialization),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(16.r),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.05),
  //             blurRadius: 10,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           Expanded(
  //             flex: 3,
  //             child: Container(
  //               margin: EdgeInsets.all(12.w),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(12.r),
  //                 color: Colors.blue.withOpacity(0.1),
  //               ),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(12.r),
  //                 child: specialization.image != null && specialization.image!.isNotEmpty
  //                     ? CachedNetworkImage(
  //                   imageUrl: specialization.image!,
  //                   fit: BoxFit.cover,
  //                   placeholder: (_, __) => _buildImagePlaceholder(),
  //                   errorWidget: (_, __, ___) => _buildImagePlaceholder(),
  //                 )
  //                     : _buildImagePlaceholder(),
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             flex: 2,
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     specialization.name ?? 'unknown_specialization'.tr(),
  //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   SizedBox(height: 4.h),
  //                   Row(
  //                     children: [
  //                       Icon(Icons.arrow_forward_ios, size: 12.w, color: Colors.blue),
  //                       SizedBox(width: 4.w),
  //                       Text(
  //                         'view_teachers'.tr(),
  //                         style: TextStyle(color: Colors.blue, fontSize: 12.sp),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildImagePlaceholder() {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [Colors.blueAccent, Colors.lightBlueAccent],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //     ),
  //     child: Center(
  //       child: Icon(Icons.school, size: 32.w, color: Colors.white),
  //     ),
  //   );
  // }

  Widget _buildSpecializationsGrid(List<SpecializationData> specializations) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<Home2Cubit>().getAllSpecializations();
      },
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Section
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'choose_specialization'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                          color: Colors.grey[900],
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Text(
                      'find_best_teachers_in_field'.tr(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.sp,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Grid Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildSpecializationCard(specializations[index], index);
                },
                childCount: specializations.length,
              ),
            ),
          ),

          // Bottom spacing
          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
        ],
      ),
    );
  }

  Widget _buildSpecializationCard(SpecializationData specialization, int index) {
    // Define gradient colors for variety
    final List<List<Color>> gradients = [
      [const Color(0xFF667eea), const Color(0xFF764ba2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      [const Color(0xFFfa709a), const Color(0xFFfee140)],
      [const Color(0xFF6a11cb), const Color(0xFF2575fc)],
    ];

    final gradientColors = gradients[index % gradients.length];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: gradientColors[0].withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Add haptic feedback
            HapticFeedback.lightImpact();

            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => ViewAllTeachers(
                  selectedSpecializationId: specialization.id!,
                  specializationName: specialization.name ?? 'Teachers',
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    )),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Image/Icon Section
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background pattern
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              backgroundBlendMode: BlendMode.overlay,
                            ),
                            child: CustomPaint(
                              painter: _PatternPainter(),
                            ),
                          ),
                        ),

                        // Content
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: specialization.image != null && specialization.image!.isNotEmpty
                              ? CachedNetworkImage(
                            imageUrl: specialization.image!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => _buildImagePlaceholder(gradientColors),
                            errorWidget: (_, __, ___) => _buildImagePlaceholder(gradientColors),
                          )
                              : _buildImagePlaceholder(gradientColors),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content Section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title
                        Text(
                          specialization.name ?? 'unknown_specialization'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Colors.grey[900],
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Action row
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: gradientColors[0].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'view_teachers'.tr(),
                                    style: TextStyle(
                                      color: gradientColors[0],
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 10.w,
                                    color: gradientColors[0],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(List<Color> gradientColors) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 32.w,
              color: Colors.white.withOpacity(0.9),
            ),
            SizedBox(height: 4.h),
            Container(
              width: 24.w,
              height: 2.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Custom painter for background pattern


  void _onSpecializationTap(SpecializationData specialization) {
    if (specialization.id != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 16.h),
                Text('loading_teachers'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ViewAllTeachers(
            selectedSpecializationId: specialization.id!,
            specializationName: specialization.name ?? 'Teachers',
          ),
        ),
      ).then((_) {
        // Close loading dialog when returning
        Navigator.of(context, rootNavigator: true).pop();
        // Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 20.0;

    // Draw diagonal lines
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}