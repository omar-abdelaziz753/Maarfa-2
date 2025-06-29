// main_model.dart (or get_teacher_details_data_model.dart)

class GetTeacherDetailsDataModel {
  bool? success;
  int? errorCode;
  int? status;
  int? notificationsCount;
  String? messages;
  TeacherDetailsData? data;

  GetTeacherDetailsDataModel({
    this.success,
    this.errorCode,
    this.status,
    this.notificationsCount,
    this.messages,
    this.data,
  });

  factory GetTeacherDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return GetTeacherDetailsDataModel(
      success: json['success'],
      errorCode: json['errorCode'],
      status: json['status'],
      notificationsCount: json['notificationsCount'],
      messages: json['messages'],
      data: json['data'] != null
          ? TeacherDetailsData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['errorCode'] = errorCode;
    data['status'] = status;
    data['notificationsCount'] = notificationsCount;
    data['messages'] = messages;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class TeacherDetailsData {
  ProviderDetails? provider;
  List<Course>? courses;
  List<Lesson>? lessons;
  List<dynamic>? consultations; // Based on empty array in JSON

  TeacherDetailsData({
    this.provider,
    this.courses,
    this.lessons,
    this.consultations,
  });

  factory TeacherDetailsData.fromJson(Map<String, dynamic> json) {
    return TeacherDetailsData(
      provider: json['provider'] != null
          ? ProviderDetails.fromJson(json['provider'])
          : null,
      courses: (json['courses'] as List<dynamic>?)
          ?.map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
      consultations: json['consultations'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (courses != null) {
      data['courses'] = courses!.map((e) => e.toJson()).toList();
    }
    if (lessons != null) {
      data['lessons'] = lessons!.map((e) => e.toJson()).toList();
    }
    data['consultations'] = consultations;
    return data;
  }
}

class ProviderDetails {
  int? id;
  String? title;
  String? degree;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? bio;
  int? status;
  int? gender;
  int? rate;
  int? rateCount;
  String? imagePath;
  String? cvPath;
  String? video;
  City? city;
  Nationality? nationality;
  List<Specialization>? specializations;
  List<EducationalStage>? educationalStages;

  ProviderDetails({
    this.id,
    this.title,
    this.degree,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.bio,
    this.status,
    this.gender,
    this.rate,
    this.rateCount,
    this.imagePath,
    this.cvPath,
    this.video,
    this.city,
    this.nationality,
    this.specializations,
    this.educationalStages,
  });

  factory ProviderDetails.fromJson(Map<String, dynamic> json) {
    return ProviderDetails(
      id: json['id'],
      title: json['title'],
      degree: json['degree'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      bio: json['bio'],
      status: json['status'],
      gender: json['gender'],
      rate: json['rate'],
      rateCount: json['rate_count'],
      imagePath: json['image_path'],
      cvPath: json['cv_path'],
      video: json['video'],
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      nationality: json['nationality'] != null
          ? Nationality.fromJson(json['nationality'])
          : null,
      specializations: (json['specializations'] as List<dynamic>?)
          ?.map((e) => Specialization.fromJson(e as Map<String, dynamic>))
          .toList(),
      educationalStages: (json['educational_stages'] as List<dynamic>?)
          ?.map((e) => EducationalStage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['degree'] = degree;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['bio'] = bio;
    data['status'] = status;
    data['gender'] = gender;
    data['rate'] = rate;
    data['rate_count'] = rateCount;
    data['image_path'] = imagePath;
    data['cv_path'] = cvPath;
    data['video'] = video;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (nationality != null) {
      data['nationality'] = nationality!.toJson();
    }
    if (specializations != null) {
      data['specializations'] = specializations!.map((e) => e.toJson()).toList();
    }
    if (educationalStages != null) {
      data['educational_stages'] = educationalStages!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class City {
  int? id;
  String? name;

  City({this.id, this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Nationality {
  int? id;
  String? name;

  Nationality({this.id, this.name});

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

// Reusing Specialization if it's the same structure as in GetAllTeachersDataModel
// If different, define a new one. Based on the JSON, it's the same.
class Specialization {
  int? id;
  String? name;
  String? image;

  Specialization({this.id, this.name, this.image});

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class EducationalStage {
  int? id;
  String? name;
  String? image;
  List<EducationalYear>? educationalYears;

  EducationalStage({this.id, this.name, this.image, this.educationalYears});

  factory EducationalStage.fromJson(Map<String, dynamic> json) {
    return EducationalStage(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      educationalYears: (json['educational_years'] as List<dynamic>?)
          ?.map((e) => EducationalYear.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    if (educationalYears != null) {
      data['educational_years'] = educationalYears!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class EducationalYear {
  int? id;
  String? name;

  EducationalYear({this.id, this.name});

  factory EducationalYear.fromJson(Map<String, dynamic> json) {
    return EducationalYear(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Course {
  int? id;
  String? name;
  String? content;
  Specialization? specialization; // Reusing Specialization model
  int? type;
  int? attendanceType;
  int? maxStudents;
  String? location;
  String? videoUrl;
  String? image;
  int? rate;
  int? rateCount;
  int? numberOfHours;
  String? price;
  double? priceWithTax; // Using double for prices
  double? tax;
  int? subscriptions;
  bool? isBookmarked;
  int? requestsCount;
  String? createdAt;
  ProviderMin? provider; // Smaller provider object
  List<Group>? groups;
  bool? isRequested;
  String? nextTime;
  bool? isFinished;

  Course({
    this.id,
    this.name,
    this.content,
    this.specialization,
    this.type,
    this.attendanceType,
    this.maxStudents,
    this.location,
    this.videoUrl,
    this.image,
    this.rate,
    this.rateCount,
    this.numberOfHours,
    this.price,
    this.priceWithTax,
    this.tax,
    this.subscriptions,
    this.isBookmarked,
    this.requestsCount,
    this.createdAt,
    this.provider,
    this.groups,
    this.isRequested,
    this.nextTime,
    this.isFinished,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      specialization: json['specialization'] != null
          ? Specialization.fromJson(json['specialization'])
          : null,
      type: json['type'],
      attendanceType: json['attendance_type'],
      maxStudents: json['max_students'],
      location: json['location'],
      videoUrl: json['video_url'],
      image: json['image'],
      rate: json['rate'],
      rateCount: json['rate_count'],
      numberOfHours: json['number_of_hours'],
      price: json['price'],
      priceWithTax: (json['price_with_tax'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      subscriptions: json['subscriptions'],
      isBookmarked: json['is_bookmarked'],
      requestsCount: json['requests_count'],
      createdAt: json['created_at'],
      provider: json['provider'] != null
          ? ProviderMin.fromJson(json['provider'])
          : null,
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
      isRequested: json['is_requested'],
      nextTime: json['nextTime'],
      isFinished: json['is_finished'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['content'] = content;
    if (specialization != null) {
      data['specialization'] = specialization!.toJson();
    }
    data['type'] = type;
    data['attendance_type'] = attendanceType;
    data['max_students'] = maxStudents;
    data['location'] = location;
    data['video_url'] = videoUrl;
    data['image'] = image;
    data['rate'] = rate;
    data['rate_count'] = rateCount;
    data['number_of_hours'] = numberOfHours;
    data['price'] = price;
    data['price_with_tax'] = priceWithTax;
    data['tax'] = tax;
    data['subscriptions'] = subscriptions;
    data['is_bookmarked'] = isBookmarked;
    data['requests_count'] = requestsCount;
    data['created_at'] = createdAt;
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (groups != null) {
      data['groups'] = groups!.map((e) => e.toJson()).toList();
    }
    data['is_requested'] = isRequested;
    data['nextTime'] = nextTime;
    data['is_finished'] = isFinished;
    return data;
  }
}

class Group {
  int? id;
  String? startFrom;
  TimeDetails? start;
  TimeDetails? end;
  DurationDetails? duration;

  Group({this.id, this.startFrom, this.start, this.end, this.duration});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      startFrom: json['start_from'],
      start: json['start'] != null ? TimeDetails.fromJson(json['start']) : null,
      end: json['end'] != null ? TimeDetails.fromJson(json['end']) : null,
      duration: json['duration'] != null
          ? DurationDetails.fromJson(json['duration'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['start_from'] = startFrom;
    if (start != null) {
      data['start'] = start!.toJson();
    }
    if (end != null) {
      data['end'] = end!.toJson();
    }
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    return data;
  }
}

class TimeDetails {
  String? date;
  String? time;
  String? dayOfWeek;
  List<String>? times; // The key is 'times', but values are days of week strings

  TimeDetails({this.date, this.time, this.dayOfWeek, this.times});

  factory TimeDetails.fromJson(Map<String, dynamic> json) {
    return TimeDetails(
      date: json['date'],
      time: json['time'],
      dayOfWeek: json['dayOfWeek'],
      times: (json['times'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['date'] = date;
    data['time'] = time;
    data['dayOfWeek'] = dayOfWeek;
    data['times'] = times;
    return data;
  }
}

class DurationDetails {
  int? number;
  String? type;

  DurationDetails({this.number, this.type});

  factory DurationDetails.fromJson(Map<String, dynamic> json) {
    return DurationDetails(
      number: json['number'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['number'] = number;
    data['type'] = type;
    return data;
  }
}

class ProviderMin {
  int? id;
  String? title;
  String? degree;
  String? firstName;
  String? lastName;
  String? image;
  String? bio;
  int? rate;
  int? rateCount;
  bool? isFinished;

  ProviderMin({
    this.id,
    this.title,
    this.degree,
    this.firstName,
    this.lastName,
    this.image,
    this.bio,
    this.rate,
    this.rateCount,
    this.isFinished,
  });

  factory ProviderMin.fromJson(Map<String, dynamic> json) {
    return ProviderMin(
      id: json['id'],
      title: json['title'],
      degree: json['degree'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      image: json['image'],
      bio: json['bio'],
      rate: json['rate'],
      rateCount: json['rate_count'],
      isFinished: json['is_finished'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['degree'] = degree;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['image'] = image;
    data['bio'] = bio;
    data['rate'] = rate;
    data['rate_count'] = rateCount;
    data['is_finished'] = isFinished;
    return data;
  }
}

class Lesson {
  int? id;
  EducationalStage? educationalStage;
  EducationalYear? educationalYear;
  Subject? subject;
  String? content;
  String? hourPrice;
  double? priceWithTax;
  double? tax;
  bool? isLive;
  dynamic hostUrl;
  dynamic joinUrl;
  List<LessonTime>? times;
  int? subscriptions;
  ProviderMin? provider; // Reusing ProviderMin
  int? requestsCount;
  bool? isBookmarked;
  bool? isRequested;
  String? nextTime;
  bool? isFinished;
  int? rate;
  int? rateCount;

  Lesson({
    this.id,
    this.educationalStage,
    this.educationalYear,
    this.subject,
    this.content,
    this.hourPrice,
    this.priceWithTax,
    this.tax,
    this.isLive,
    this.hostUrl,
    this.joinUrl,
    this.times,
    this.subscriptions,
    this.provider,
    this.requestsCount,
    this.isBookmarked,
    this.isRequested,
    this.nextTime,
    this.isFinished,
    this.rate,
    this.rateCount,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      educationalStage: json['educational_stage'] != null
          ? EducationalStage.fromJson(json['educational_stage'])
          : null,
      educationalYear: json['educational_year'] != null
          ? EducationalYear.fromJson(json['educational_year'])
          : null,
      subject: json['subject'] != null
          ? Subject.fromJson(json['subject'])
          : null,
      content: json['content'],
      hourPrice: json['hour_price'],
      priceWithTax: (json['price_with_tax'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      isLive: json['isLive'],
      hostUrl: json['host_url'],
      joinUrl: json['join_url'],
      times: (json['times'] as List<dynamic>?)
          ?.map((e) => LessonTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      subscriptions: json['subscriptions'],
      provider: json['provider'] != null
          ? ProviderMin.fromJson(json['provider'])
          : null,
      requestsCount: json['requests_count'],
      isBookmarked: json['is_bookmarked'],
      isRequested: json['is_requested'],
      nextTime: json['nextTime'],
      isFinished: json['is_finished'],
      rate: json['rate'],
      rateCount: json['rate_count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (educationalStage != null) {
      data['educational_stage'] = educationalStage!.toJson();
    }
    if (educationalYear != null) {
      data['educational_year'] = educationalYear!.toJson();
    }
    if (subject != null) {
      data['subject'] = subject!.toJson();
    }
    data['content'] = content;
    data['hour_price'] = hourPrice;
    data['price_with_tax'] = priceWithTax;
    data['tax'] = tax;
    data['isLive'] = isLive;
    data['host_url'] = hostUrl;
    data['join_url'] = joinUrl;
    if (times != null) {
      data['times'] = times!.map((e) => e.toJson()).toList();
    }
    data['subscriptions'] = subscriptions;
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    data['requests_count'] = requestsCount;
    data['is_bookmarked'] = isBookmarked;
    data['is_requested'] = isRequested;
    data['nextTime'] = nextTime;
    data['is_finished'] = isFinished;
    data['rate'] = rate;
    data['rate_count'] = rateCount;
    return data;
  }
}

class Subject {
  int? id;
  String? name;

  Subject({this.id, this.name});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class LessonTime {
  int? id;
  String? startsAt;
  String? endsAt;

  LessonTime({this.id, this.startsAt, this.endsAt});

  factory LessonTime.fromJson(Map<String, dynamic> json) {
    return LessonTime(
      id: json['id'],
      startsAt: json['starts_at'],
      endsAt: json['ends_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['starts_at'] = startsAt;
    data['ends_at'] = endsAt;
    return data;
  }
}