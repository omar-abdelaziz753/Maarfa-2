import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/layout/view/home/user/data/models/get_teacher_details_data_model.dart';
import 'package:my_academy/layout/view/home/user/teacher_details/teacher_details_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfessionalBookingBottomSheet extends StatefulWidget {
  final TeacherDetailsData teacher;
  final Function(String date, String timeFrom, String timeTo, String type)
  onConfirm;

  const ProfessionalBookingBottomSheet({
    Key? key,
    required this.teacher,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<ProfessionalBookingBottomSheet> createState() =>
      _ProfessionalBookingBottomSheetState();

  static void show(
      BuildContext context,
      TeacherDetailsData teacher,
      Function(String date, String timeFrom, String timeTo, String type)
      onConfirm,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfessionalBookingBottomSheet(
        teacher: teacher,
        onConfirm: onConfirm,
      ),
    );
  }
}

class _ProfessionalBookingBottomSheetState
    extends State<ProfessionalBookingBottomSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTimeSlot;
  String _selectedType = 'lesson';
  String? _fromTime;
  String? _toTime;

  // Sample available time slots
  final Map<String, List<String>> _availableSlots = {
    'morning': ['09:00', '10:00', '11:00'],
    'afternoon': ['14:00', '15:00', '16:00', '17:00'],
    'evening': ['19:00', '20:00', '21:00'],
  };

  // Sample unavailable dates (you can fetch from API)
  final List<DateTime> _unavailableDates = [
    DateTime.now().add(Duration(days: 3)),
    DateTime.now().add(Duration(days: 7)),
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          _buildHeader(),

          // Tab Bar
          _buildTabBar(),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDateSelectionTab(),
                _buildWriteStartAndEndTimeCanGeneratedByStartTimeMakeAfterOneHour()
                // _buildTimeSelectionTab(),
              ],
            ),
          ),

          // Bottom Action
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildWriteStartAndEndTimeCanGeneratedByStartTimeMakeAfterOneHour() {
    if (_selectedDay == null) {
      return _buildSelectDateFirst();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected Date Summary
          _buildDateSummary(),

          SizedBox(height: 24.h),

          // Start Time Input Section
          _buildStartTimeInput(),

          SizedBox(height: 16.h),

          // Generated End Time Display
          if (_selectedStartTime != null) _buildGeneratedEndTime(),
        ],
      ),
    );
  }

  Widget _buildStartTimeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'selectStartTime'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: () => _selectStartTime(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: _selectedStartTime != null ? Colors.blue[600]! : Colors.grey[300]!,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: _selectedStartTime != null ? Colors.blue[600] : Colors.grey[500],
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    _selectedStartTime != null
                        ? _formatTime(_selectedStartTime!)
                        : 'tapToSelectStartTime'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: _selectedStartTime != null
                          ? Colors.grey[800]
                          : Colors.grey[500],
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[400],
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneratedEndTime() {
    final endTime = _generateEndTime(_selectedStartTime!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'generatedEndTime'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.schedule,
                color: Colors.grey[600],
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                _formatTime(endTime),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '(+1 hour)',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Time slot summary
        _buildTimeSlotSummary(),
      ],
    );
  }

  Widget _buildTimeSlotSummary() {
    final startTime = _selectedStartTime!;
    final endTime = _generateEndTime(startTime);
    final timeSlot = '${_formatTime(startTime)} - ${_formatTime(endTime)}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'selectedTimeSlot'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.blue[700],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            timeSlot,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }

// Helper methods to add to your class
  TimeOfDay? _selectedStartTime;

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedStartTime) {
      setState(() {
        _selectedStartTime = picked;
        // Update the time slot string for compatibility
        final endTime = _generateEndTime(picked);
        _selectedTimeSlot = '${_formatTime(picked)} - ${_formatTime(endTime)}';
        _parseSelectedTimeSlot(); // If you have this method
      });
    }
  }

  TimeOfDay _generateEndTime(TimeOfDay startTime) {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = startMinutes + 60; // Add 1 hour

    final endHour = (endMinutes ~/ 60) % 24; // Handle overflow to next day
    final endMinute = endMinutes % 60;

    return TimeOfDay(hour: endHour, minute: endMinute);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundImage: widget.teacher.provider?.imagePath != null
                ? NetworkImage(widget.teacher.provider!.imagePath!)
                : null,
            child: widget.teacher.provider?.imagePath == null
                ? Icon(Icons.person, size: 25.w)
                : null,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'book'.tr()} ${widget.teacher.provider?.firstName ?? "المدرس"}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.teacher.provider?.specializations
                      ?.map((s) => s.name)
                      .join(', ') ??
                      'Teacher',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.blue[600],
          borderRadius: BorderRadius.circular(12.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 18.w),
                SizedBox(width: 8.w),
                Text('selectDate'.tr()),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, size: 18.w),
                SizedBox(width: 8.w),
                Text('selectTime'.tr()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lesson Type Selection
          _buildLessonTypeSection(),

          SizedBox(height: 24.h),

          // Calendar
          _buildCalendar(),

          SizedBox(height: 16.h),

          // Selected Date Info
          if (_selectedDay != null) _buildSelectedDateInfo(),
        ],
      ),
    );
  }

  Widget _buildTimeSelectionTab() {
    if (_selectedDay == null) {
      return _buildSelectDateFirst();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected Date Summary
          _buildDateSummary(),

          SizedBox(height: 24.h),

          // Time Slots
          _buildTimeSlots(),
        ],
      ),
    );
  }

  Widget _buildLessonTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'lessonType'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child:
              _buildTypeOption('lesson', Icons.school, 'lessonee'.tr(), '60 min'),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildTypeOption(
                  'course', Icons.library_books, 'courseee'.tr(), '90 min'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeOption(
      String type, IconData icon, String label, String duration) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.grey[50],
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue[600] : Colors.grey[600],
              size: 28.w,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue[600] : Colors.grey[800],
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              duration,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(Duration(days: 90)),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        eventLoader: (day) => [],
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(color: Colors.grey[600]),
          holidayTextStyle: TextStyle(color: Colors.red),
          defaultTextStyle: TextStyle(color: Colors.grey[800]),
          todayTextStyle: TextStyle(color: Colors.white),
          selectedTextStyle: TextStyle(color: Colors.white),
          todayDecoration: BoxDecoration(
            color: Colors.blue[400],
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.blue[600],
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue[600]),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue[600]),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!_unavailableDates.any((date) => isSameDay(date, selectedDay))) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        enabledDayPredicate: (day) {
          return !_unavailableDates.any((date) => isSameDay(date, day));
        },
      ),
    );
  }

  Widget _buildSelectedDateInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.blue[600],
            size: 20.w,
          ),
          SizedBox(width: 12.w),
          Text(
            'selectedDate'.tr() +
                ': ${DateFormat('EEEE, MMM dd, yyyy').format(_selectedDay!)}',
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectDateFirst() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 64.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'selectDateFirst'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'pleaseSelectDate'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => _tabController.animateTo(0),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('goToCalendar'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSummary() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 24.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE').format(_selectedDay!),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDay!),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'availableTime'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16.h),
        ..._availableSlots.entries
            .map((entry) => _buildTimeSlotSection(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildTimeSlotSection(String period, List<String> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          period.tr(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: slots.map((slot) => _buildTimeSlot(slot)).toList(),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildTimeSlot(String time) {
    final endTime = _getEndTime(time);
    final timeSlot = '$time - $endTime';
    final isSelected = _selectedTimeSlot == timeSlot;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeSlot = timeSlot;
          _parseSelectedTimeSlot();
        });
      },
      // onTap: () => setState(() => _selectedTimeSlot = timeSlot),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.blue[600]!.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Text(
          timeSlot,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    final canConfirm = _selectedDay != null && _selectedTimeSlot != null;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedDay != null && _selectedTimeSlot != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${DateFormat('MMM dd').format(_selectedDay!)} • $_selectedTimeSlot • ${_selectedType == 'lesson' ? 'Lesson' : 'Course'}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('Confirm booking');
                  print(formatDate(_selectedDay.toString()));
                  print(_fromTime);
                  print(_toTime);
                  print(_selectedType);
                  canConfirm ? _confirmBooking() : null;
                },
                // onPressed: canConfirm ? _confirmBooking : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: canConfirm ? 2 : 0,
                ),
                child: Text(
                  'confirmBooking'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  void _parseSelectedTimeSlot() {
    if (_selectedTimeSlot != null) {
      final parts = _selectedTimeSlot!.split(' - ');
      if (parts.length == 2) {
        _fromTime = parts[0];
        _toTime = parts[1];
      }
    }
  }

  String _getEndTime(String startTime) {
    final start = TimeOfDay(
      hour: int.parse(startTime.split(':')[0]),
      minute: int.parse(startTime.split(':')[1]),
    );

    final duration = _selectedType == 'lesson' ? 60 : 90;
    final endMinutes = start.hour * 60 + start.minute + duration;
    final endHour = (endMinutes ~/ 60) % 24;
    final endMinute = endMinutes % 60;

    return '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
  }

  void _confirmBooking() {
    if (_selectedDay != null && _selectedTimeSlot != null) {
      final timeParts = _selectedTimeSlot!.split(' - ');
      final dateString = DateFormat('yyyy-MM-dd').format(_selectedDay!);

      widget.onConfirm(dateString, timeParts[0], timeParts[1], _selectedType);
      Navigator.pop(context);
    }
  }

  static void show(
      BuildContext context,
      TeacherDetailsData teacher,
      Function(String date, String timeFrom, String timeTo, String type)
      onConfirm,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfessionalBookingBottomSheet(
        teacher: teacher,
        onConfirm: onConfirm,
      ),
    );
  }
}
