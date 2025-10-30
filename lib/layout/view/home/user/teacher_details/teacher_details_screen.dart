import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/bloc/add_request/add_request_cubit.dart';
import 'package:my_academy/layout/view/home/user/data/models/get_teacher_details_data_model.dart';
import 'package:my_academy/layout/view/home/user/teacher_details/profissional_booking_bottom_sheet.dart';
import 'package:my_academy/service/local/share_prefs_service.dart';
import 'package:my_academy/widget/toast/toast.dart';

import '../data/cubit/home_cubit.dart';
import '../data/cubit/home_state.dart';

class TeacherDetailsScreen extends StatefulWidget {
  final String teacherId;

  const TeacherDetailsScreen({
    super.key,
    required this.teacherId,
  });

  @override
  State<TeacherDetailsScreen> createState() => _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends State<TeacherDetailsScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _appBarAnimationController;
  late AnimationController _bookingButtonController;
  bool _isAppBarExpanded = true;

  bool _isSelectionMode = false;
  String? _selectedLesson;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _appBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bookingButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scrollController.addListener(_onScroll);

    _fetchTeacherDetails();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _bookingButtonController.forward();
      }
    });
  }

  void _fetchTeacherDetails() {
    final teacherId = int.tryParse(widget.teacherId);
    if (teacherId != null) {
      context.read<Home2Cubit>().getTeacherDetails(providerId: teacherId);
    }
  }

  void _onScroll() {
    const offset = 200.0;
    if (_scrollController.offset > offset && _isAppBarExpanded) {
      setState(() => _isAppBarExpanded = false);
      _appBarAnimationController.forward();
    } else if (_scrollController.offset <= offset && !_isAppBarExpanded) {
      setState(() => _isAppBarExpanded = true);
      _appBarAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _appBarAnimationController.dispose();
    _bookingButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocProvider(
        create: (context) => AddRequestCubit(),
        child: BlocBuilder<Home2Cubit, Home2State>(
          builder: (context, state) {
            if (state is GetTeacherDetailsLoadingState) {
              return _buildLoadingScreen();
            } else if (state is GetTeacherDetailsErrorState) {
              return _buildErrorScreen(state.errorMessage);
            } else if (state is GetTeacherDetailsSuccessState) {
              final teacher =
                  context.read<Home2Cubit>().teacherDetailsDataModel?.data;
              if (teacher == null) {
                return _buildErrorScreen('teacher_data_not_available'.tr());
              }
              return _buildSuccessScreen(teacher);
            }
            return _buildLoadingScreen();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: Colors.red[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'something_went_wrong'.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _fetchTeacherDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'retry'.tr(),
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScreen(TeacherDetailsData teacher) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(teacher),
            SliverToBoxAdapter(child: _buildTeacherInfo(teacher)),
            SliverToBoxAdapter(child: _buildStatsSection(teacher)),
            SliverToBoxAdapter(child: _buildAboutSection(teacher)),
            SliverToBoxAdapter(child: _buildEducationSection(teacher)),
            SliverToBoxAdapter(child: _buildLessonsSection(teacher)),
            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
        _buildBookingButton(teacher),
      ],
    );
  }

  Widget _buildSliverAppBar(TeacherDetailsData teacher) {
    final fullName =
        '${teacher.provider?.firstName ?? ''} ${teacher.provider?.lastName ?? ''}'
            .trim();

    return SliverAppBar(
      expandedHeight: 300.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.w),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // actions: [
      //   Container(
      //     margin: EdgeInsets.all(8.w),
      //     decoration: BoxDecoration(
      //       color: Colors.black.withValues(alpha: 0.3),
      //       borderRadius: BorderRadius.circular(12.r),
      //     ),
      //     child: IconButton(
      //       icon: Icon(Icons.description_outlined,
      //           color: Colors.white, size: 20.w),
      //       onPressed: () {
      //         HapticFeedback.lightImpact();
      //       },
      //     ),
      //   ),
      // ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  Hero(
                    tag: 'teacher_avatar_${teacher.provider?.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: teacher.provider?.imagePath != null &&
                                teacher.provider!.imagePath!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: teacher.provider!.imagePath!,
                                width: 120.w,
                                height: 120.h,
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    _buildAvatarPlaceholder(),
                                errorWidget: (_, __, ___) =>
                                    _buildDefaultAvatar(),
                              )
                            : _buildDefaultAvatar(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    fullName.isNotEmpty ? fullName : 'name_not_available'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (teacher.provider?.title != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      teacher.provider!.title!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherInfo(TeacherDetailsData teacher) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600], size: 24.w),
              SizedBox(width: 12.w),
              Text(
                'teacher_info'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (teacher.provider?.specializations != null) ...[
            _buildInfoRow(
                Icons.school_outlined,
                'specialization'.tr(),
                teacher.provider!.specializations!
                    .map((spec) => spec.name ?? '')
                    .where((name) => name.isNotEmpty)
                    .join(', ')),
            SizedBox(height: 12.h),
          ],
          if (teacher.provider?.degree != null) ...[
            _buildInfoRow(
                Icons.workspace_premium_outlined,
                'qualification'.tr(),
                teacher.provider?.degree ?? 'no_qualification'.tr()),
            SizedBox(height: 12.h),
          ],
          // if (teacher.provider?.phone != null) ...[
          //   _buildInfoRow(Icons.phone_outlined, 'phoneNumber'.tr(),
          //       teacher.provider?.phone ?? 'no_phone_number'.tr()),
          //   SizedBox(height: 12.h),
          // ],
          // if (teacher.provider?.email != null) ...[
          //   _buildInfoRow(Icons.email_outlined, 'emailAddress'.tr(),
          //       teacher.provider?.email ?? 'no_email'.tr()),
          // ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: 20.w),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(TeacherDetailsData teacher) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
              child: _buildStatCard(
                  'ratee'.tr(),
                  teacher.provider?.rate?.toStringAsFixed(1) ?? '0.0',
                  Icons.star,
                  Colors.amber)),
          SizedBox(width: 12.w),
          Expanded(
              child: _buildStatCard(
                  'students'.tr(),
                  '${teacher.provider?.rateCount ?? 0}',
                  Icons.people,
                  Colors.blue)),
          SizedBox(width: 12.w),
          Expanded(
              child: _buildStatCard(
                  'coursess'.tr(),
                  '${teacher.lessons?.length ?? 0}',
                  Icons.play_lesson,
                  Colors.green)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.w),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(TeacherDetailsData teacher) {
    final aboutText = teacher.provider?.bio?.isNotEmpty == true
        ? teacher.provider?.bio!
        : '${teacher.provider?.title ?? "teacher".tr()} ${'specialized_in'.tr()} ${teacher.provider?.specializations ?? teacher.provider?.degree ?? "education".tr()}';

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: Colors.blue[600], size: 24.w),
              SizedBox(width: 12.w),
              Text(
                'aboutOfTeacher'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            aboutText ?? '',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLessonTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(timeString);
      final now = DateTime.now();
      final difference = dateTime.difference(now);

      if (difference.inDays > 0) {
        return '${'during'.tr()} ${difference.inDays} ${'dayss'.tr()}';
      } else if (difference.inHours > 0) {
        return '${'during'.tr()} ${difference.inHours} ${'hourss'.tr()}';
      } else if (difference.inMinutes > 0) {
        return '${'during'.tr()} ${difference.inMinutes} ${'minutess'.tr()}';
      } else {
        return 'now'.tr();
      }
    } catch (e) {
      return timeString;
    }
  }

  Widget _buildLessonCard(Lesson lesson) {
    final nextTime = _formatLessonTime(lesson.nextTime);
    final priceText = lesson.hourPrice != null
        ? '${lesson.hourPrice} ${'SAR/hour'.tr()}'
        : 'pppp'.tr();

    final isSelected = _selectedLesson ==
        (lesson.id?.toString() ?? lesson.hashCode.toString());

    return GestureDetector(
      onTap: _isSelectionMode ? () => _toggleLessonSelection(lesson) : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.grey[50],
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[200]!,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (_isSelectionMode) ...[
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.blue[600] : Colors.transparent,
                      border: Border.all(
                        color:
                            isSelected ? Colors.blue[600]! : Colors.grey[400]!,
                        width: 2.0,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16.w,
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (lesson.subject?.name != null)
                        Text(
                          lesson.subject!.name!,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      if (lesson.content != null &&
                          lesson.content!.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          lesson.content!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: lesson.isLive == true
                            ? Colors.red[50]
                            : Colors.green[50],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        lesson.isLive == true
                            ? 'livee'.tr()
                            : 'registered'.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: lesson.isLive == true
                              ? Colors.red[600]
                              : Colors.green[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (lesson.rate != null && lesson.rate! > 0) ...[
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 12.w),
                          SizedBox(width: 2.w),
                          Text(
                            '${lesson.rate}',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                if (lesson.educationalStage?.name != null) ...[
                  Icon(Icons.school, color: Colors.blue[600], size: 14.w),
                  SizedBox(width: 4.w),
                  Text(
                    lesson.educationalStage!.name!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                if (nextTime.isNotEmpty) ...[
                  Icon(Icons.access_time,
                      color: Colors.orange[600], size: 14.w),
                  SizedBox(width: 4.w),
                  Text(
                    nextTime,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  priceText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (lesson.subscriptions != null && lesson.subscriptions! > 0) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.people, color: Colors.grey[500], size: 14.w),
                  SizedBox(width: 4.w),
                  Text(
                    '${lesson.subscriptions} ${'subscriptionss'.tr()}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.cyan[50]!],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.blue[100]!, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue[100]!.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[600]!, Colors.blue[700]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue[600]!.withValues(alpha: 0.3),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.schedule_rounded,
                      size: 14.w,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTimeRange(lesson.times?.first),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        if (_calculateDuration(
                          lesson.times?.first.startsAt ?? '',
                          lesson.times?.first.endsAt ?? '',
                        ).isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            _calculateDuration(
                              lesson.times?.first.startsAt ?? '',
                              lesson.times?.first.endsAt ?? '',
                            ),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
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

  String _formatTimeRange(LessonTime? time) {
    if (time == null || time.startsAt == null || time.endsAt == null) {
      return '';
    }

    final start = formatTime(context, time.startsAt!);
    final end = formatTime(context, time.endsAt!);

    return '$start - $end';
  }

  String formatTime(BuildContext context, String timeString) {
    try {
      final time = DateTime.parse('1970-01-01T$timeString');
      final timeOfDay = TimeOfDay.fromDateTime(time);
      return timeOfDay.format(context);
    } catch (e) {
      return timeString;
    }
  }

  Widget _buildTimeDisplay(Lesson lesson) {
    if (lesson.times == null || lesson.times!.isEmpty) {
      return SizedBox.shrink();
    }

    if (lesson.times!.length > 1) {
      return _buildMultipleTimesDisplay(lesson.times!);
    }

    return _buildSingleTimeDisplay(lesson.times!.first);
  }

  Widget _buildSingleTimeDisplay(LessonTime time) {
    final timeRange = _formatProfessionalTimeRange(time);
    final dayInfo = _formatDayInfo(time);

    if (timeRange.isEmpty && dayInfo.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.indigo[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue[100]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dayInfo.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    dayInfo,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
          ],
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.schedule_rounded,
                  size: 12.w,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  timeRange.isNotEmpty ? timeRange : 'Time TBD',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleTimesDisplay(List<LessonTime> times) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[50]!, Colors.indigo[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.purple[100]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.purple[600],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Multiple Sessions',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${times.length} ${'sessions'.tr()}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.purple[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ...times.take(2).map((time) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: Colors.purple[600],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        _formatCompactTimeRange(time),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.purple[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          if (times.length > 2) ...[
            SizedBox(height: 4.h),
            Text(
              '+${times.length - 2} ${'more sessions'.tr()}',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.purple[600],
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatProfessionalTimeRange(LessonTime? time) {
    if (time == null || time.startsAt == null || time.endsAt == null) {
      return '';
    }

    final start = _formatProfessionalTime(time.startsAt!);
    final end = _formatProfessionalTime(time.endsAt!);
    final duration = _calculateDuration(time.startsAt!, time.endsAt!);

    return '$start → $end${duration.isNotEmpty ? ' ($duration)' : ''}';
  }

  String _formatCompactTimeRange(LessonTime? time) {
    if (time == null || time.startsAt == null || time.endsAt == null) {
      return '';
    }

    final start = _formatProfessionalTime(time.startsAt!);
    final end = _formatProfessionalTime(time.endsAt!);
    final dayInfo = _formatDayInfo(time);

    return '${dayInfo.isNotEmpty ? '$dayInfo: ' : ''}$start - $end';
  }

  String _formatProfessionalTime(String timeString) {
    try {
      final time = DateTime.parse('1970-01-01T$timeString');
      final hour = time.hour;
      final minute = time.minute;

      if (hour == 0) {
        return '12:${minute.toString().padLeft(2, '0')} AM';
      } else if (hour < 12) {
        return '$hour:${minute.toString().padLeft(2, '0')} AM';
      } else if (hour == 12) {
        return '12:${minute.toString().padLeft(2, '0')} PM';
      } else {
        return '${hour - 12}:${minute.toString().padLeft(2, '0')} PM';
      }
    } catch (e) {
      return timeString;
    }
  }

  String _formatDayInfo(LessonTime? time) {
    if (time?.startsAt == null) return '';

    try {
      final dateTime = DateTime.parse(time!.startsAt!);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      final difference = targetDate.difference(today).inDays;

      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Tomorrow';
      } else if (difference == -1) {
        return 'Yesterday';
      } else if (difference > 1 && difference < 7) {
        const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return weekdays[dateTime.weekday - 1];
      } else {
        return '${dateTime.day}/${dateTime.month}';
      }
    } catch (e) {
      return '';
    }
  }

  String _calculateDuration(String startTime, String endTime) {
    try {
      final start = DateTime.parse('1970-01-01T$startTime');
      final end = DateTime.parse('1970-01-01T$endTime');
      final duration = end.difference(start);

      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;

      if (hours > 0 && minutes > 0) {
        return '${hours}h ${minutes}m';
      } else if (hours > 0) {
        return '${hours}h';
      } else if (minutes > 0) {
        return '${minutes}m';
      }

      return '';
    } catch (e) {
      return '';
    }
  }

  String _formatDayInfoWithDate(LessonTime? time, DateTime? lessonDate) {
    if (lessonDate == null) return time?.startsAt ?? '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate =
        DateTime(lessonDate.year, lessonDate.month, lessonDate.day);

    final difference = targetDate.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 1 && difference < 7) {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[lessonDate.weekday - 1];
    } else {
      return '${lessonDate.day}/${lessonDate.month}';
    }
  }

  String _formatTimeInfo(LessonTime? time) {
    if (time == null) return '';

    String result = '';
    if (time.startsAt != null) {
      result += time.startsAt!;
    }
    if (time.endsAt != null) {
      result += time.startsAt != null ? ' - ${time.endsAt!}' : time.endsAt!;
    }
    return result;
  }

  Widget _buildLessonsSection(TeacherDetailsData teacher) {
    if (teacher.lessons == null || teacher.lessons!.isEmpty) {
      return Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.play_lesson, color: Colors.blue[600], size: 24.w),
                SizedBox(width: 12.w),
                Text(
                  'lessons'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 48.w,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'no_lessonsً'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.play_lesson, color: Colors.blue[600], size: 24.w),
              SizedBox(width: 12.w),
              Text(
                'available_lessons'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              if (_isSelectionMode && _selectedLesson != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '1 ${'selected'.tr()}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.green[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${teacher.lessons!.length} ${'lessonWW'.tr()}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...teacher.lessons!.take(3).map((lesson) => _buildLessonCard(lesson)),
          if (teacher.lessons!.length > 3) ...[
            SizedBox(height: 12.h),
            Center(
              child: TextButton(
                onPressed: () => _showAllLessons(teacher.lessons!),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue[600],
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${'view_all_lessons'.tr()} (${teacher.lessons!.length})',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.arrow_forward_ios, size: 14.w),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAllLessons(List<Lesson> lessons) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAllLessonsBottomSheet(lessons),
    );
  }

  Widget _buildAllLessonsBottomSheet(List<Lesson> lessons) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(top: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    Text(
                      'all_lessons'.tr(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _toggleSelectionMode();
                        });

                        this.setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: _isSelectionMode
                              ? Colors.green[50]
                              : Colors.blue[50],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isSelectionMode
                                  ? Icons.check_circle
                                  : Icons.list_alt,
                              size: 16.w,
                              color: _isSelectionMode
                                  ? Colors.green[600]
                                  : Colors.blue[600],
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              _isSelectionMode
                                  ? 'Selection Mode'.tr()
                                  : 'Select Mode'.tr(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: _isSelectionMode
                                    ? Colors.green[600]
                                    : Colors.blue[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${lessons.length} ${'lessonWW'.tr()}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isSelectionMode && _selectedLesson != null) ...[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.green[200]!, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16.w,
                            color: Colors.green[600],
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '1 ${'lesson selected'.tr()}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedLesson = null;
                          });

                          this.setState(() {});
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          'Clear'.tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.red[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
              ],
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    return _buildLessonCard(lessons[index]);
                  },
                ),
              ),
              if (_isSelectionMode && _selectedLesson != null) ...[
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pop(context);

                        final selectedLessonObj = getSelectedLesson(lessons);

                        if (selectedLessonObj != null) {
                          final addRequestState =
                              context.read<AddRequestCubit>();

                          // print('Selected Lesson ID: ${selectedLessonObj.id}');
                          // print(
                          //     'Selected Lesson Duration: ${selectedLessonObj.times?.first}');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, size: 20.w),
                          SizedBox(width: 8.w),
                          Text(
                            'Book Selected Lesson'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEducationSection(TeacherDetailsData teacher) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school_outlined, color: Colors.blue[600], size: 24.w),
              SizedBox(width: 12.w),
              Text(
                'educationAndExperience'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (teacher.provider?.degree != null)
            _buildEducationItem(
              teacher.provider?.degree ?? '',
              teacher.provider?.specializations
                      ?.map((spec) => spec.name ?? '')
                      .where((name) => name.isNotEmpty)
                      .join(', ') ??
                  '',
              '',
            ),
        ],
      ),
    );
  }

  Widget _buildEducationItem(String institution, String degree, String period) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: Colors.blue[600],
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                institution,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              if (degree.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  degree,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedLesson = null;
      }
    });
  }

  void _toggleLessonSelection(Lesson lesson) {
    setState(() {
      final lessonId = lesson.id?.toString() ?? lesson.hashCode.toString();

      if (_selectedLesson == lessonId) {
        _selectedLesson = null;
      } else {
        _selectedLesson = lessonId;
      }
    });
  }

  Widget _buildBookingButton(TeacherDetailsData teacher) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _bookingButtonController,
          curve: Curves.easeOutCubic,
        )),
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            spacing: 14.w,
            children: [
              Expanded(
                child: BlocBuilder<AddRequestCubit, AddRequestState>(
                  builder: (context, state) {
                    final addRequestState = context.read<AddRequestCubit>();

                    return ElevatedButton(
                      onPressed: _selectedLesson != null
                          ? () {
                              // print('Selected lesson: $_selectedLesson');

                              final selectedLessonObj =
                                  getSelectedLesson(teacher.lessons ?? []);

                              if (selectedLessonObj != null) {
                                List<int> lessonTimes = [];
                                if (selectedLessonObj.times != null &&
                                    selectedLessonObj.times!.isNotEmpty) {
                                  lessonTimes = selectedLessonObj.times!
                                      .where((time) => time.id != null)
                                      .map((time) => time.id!)
                                      .toList();
                                }

                                if (lessonTimes.isEmpty) {
                                  showToast(
                                      "This lesson has no available time slots".tr());
                                  return;
                                }

                                addRequestState.times.clear();
                                addRequestState.times.addAll(lessonTimes);

                                // print('Lesson Times: $lessonTimes');

                                addRequestState.addRequestLesson(
                                  lessonId: int.parse(_selectedLesson!),
                                  // type: 'lesson',
                                  times: lessonTimes,
                                  context: context,
                                );
                              }
                            }
                          : () => _toggleSelectionMode(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedLesson != null
                            ? Colors.green[600]
                            : Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              _selectedLesson != null
                                  ? Icons.check_circle
                                  : Icons.list_alt,
                              size: 20.w),
                          SizedBox(width: 8.w),
                          Text(
                            _selectedLesson != null
                                ? 'Book Selected Lesson'.tr()
                                : _isSelectionMode
                                    ? 'Cancel Selection'.tr()
                                    : 'Select Lesson'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _onBookNowPressed(teacher),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 20.w),
                      SizedBox(width: 8.w),
                      Text(
                        'bookANewDate'.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimeSelectionDialog(
      Lesson lesson, AddRequestCubit addRequestState) {
    if (lesson.times == null || lesson.times!.isEmpty) {
      showToast("This lesson has no available time slots");
      return;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Select Time Slots'.tr()),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: lesson.times!.length,
              itemBuilder: (context, index) {
                final time = lesson.times![index];
                final isSelected = addRequestState.times.contains(time.id);

                return CheckboxListTile(
                  title: Text(
                    '${time.startsAt} - ${time.endsAt}',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        if (!addRequestState.times.contains(time.id)) {
                          addRequestState.times.add(time.id!);
                        }
                      } else {
                        addRequestState.times.remove(time.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            BlocListener<AddRequestCubit, AddRequestState>(
              listener: (context, state) {
                if (state is ValidateRequest) {}
              },
              child: ElevatedButton(
                onPressed: addRequestState.times.isNotEmpty
                    ? () {
                        Navigator.pop(context);
                        addRequestState.addRequestLesson(
                          lessonId: lesson.id!,
                        times: addRequestState.times,
                          context: context,
                        );
                      }
                    : null,
                child: Text('Book Lesson'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
      ),
      child: Icon(
        Icons.person_outline,
        size: 60.w,
        color: Colors.white,
      ),
    );
  }

  String convertArabicToEnglishNumbers(String input) {
    const arabic = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    const english = ['0','1','2','3','4','5','6','7','8','9'];

    for (int i = 0; i < arabic.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }

  String formatDateToEnglish(String date) {
    String englishDate = convertArabicToEnglishNumbers(date);
    DateTime parsed = DateTime.parse(englishDate);
    return "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}";
  }

  void _onBookNowPressed(TeacherDetailsData teacher) {
    HapticFeedback.mediumImpact();

    ProfessionalBookingBottomSheet.show(
      context,
      teacher,
      (String date, String timeFrom, String timeTo, String type) {
        _handleBookingWithConsumer(
          teacher: teacher,
          date: formatDateToEnglish(date),
          timeFrom: timeFrom,
          timeTo: timeTo,
          type: type,
        );
      },
    );
  }

  Future<void> _handleBookingWithConsumer({
    required TeacherDetailsData teacher,
    required String date,
    required String timeFrom,
    required String timeTo,
    required String type,
  }) async {
    SharedPrefService prefService = SharedPrefService();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocConsumer<Home2Cubit, Home2State>(
        listener: (context, state) {
          if (state is MakeBookSuccessState) {
            // Navigator.of(dialogContext).pop();
            //
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text('Booking confirmed successfully!'),
            //     backgroundColor: Colors.green,
            //     duration: Duration(seconds: 2),
            //   ),
            // );
            //
            // Future.delayed(Duration(milliseconds: 500), () {});
          } else if (state is MakeBookErrorState) {
            Navigator.of(dialogContext).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    state.errorMessage ?? 'Booking failed. Please try again.'.tr()),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing your booking...'.tr()),
              ],
            ),
          );
        },
      ),
    );

    final cubit = context.read<Home2Cubit>();
    cubit.makeBook(
      clientId: await prefService.getValue('user_id'),
      date: formatDateToEnglish(date),
      timeFrom: timeFrom,
      timeTo: timeTo,
      type: type,
      teacherId: teacher.provider!.id.toString(),
      context: context,
    );
    // print('-------------');
    // print(date);
    // print('-------------');

    // print("date is ======== $date");
    // print("timeFrom $timeFrom");
    // print("timeTo $timeTo");
    // print("type $type");
    // print("teacherId ${teacher.provider!.id.toString()}");
  }

  Lesson? getSelectedLesson(List<Lesson> lessons) {
    if (_selectedLesson == null) return null;

    try {
      return lessons.firstWhere((lesson) =>
          (lesson.id?.toString() ?? lesson.hashCode.toString()) ==
          _selectedLesson);
    } catch (e) {
      return null;
    }
  }
}

enum LessonType {
  course,
  lesson;

  String get title {
    switch (this) {
      case LessonType.course:
        return 'Course';
      case LessonType.lesson:
        return 'Lesson';
    }
  }
}
