import 'dart:convert';

OnlineEmployee onlineEmployeeFromJson(String str) => OnlineEmployee.fromJson(json.decode(str));

class OnlineEmployee {
  OnlineEmployee({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.data,
    required this.support,
  });

  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<EmployeeList> data;
  final Support? support;

  factory OnlineEmployee.fromJson(Map<String, dynamic> json) => OnlineEmployee(
        page: json["page"] ?? 1,
        perPage: json["per_page"] ?? 1,
        total: json["total"] ?? 1,
        totalPages: json["total_pages"] ?? 1,
        data: json["data"] == null ? [] : List<EmployeeList>.from(json["data"].map((x) => EmployeeList.fromJson(x))),
        support: json["support"] == null ? null : Support.fromJson(json["support"]),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "total": total,
        "total_pages": totalPages,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "support": support!.toJson(),
      };
}

class EmployeeList {
  EmployeeList({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  factory EmployeeList.fromJson(Map<String, dynamic> json) => EmployeeList(
        id: json["id"] ?? 0,
        email: json["email"] ?? '',
        firstName: json["first_name"] ?? '',
        lastName: json["last_name"] ?? '',
        avatar: json["avatar"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
      };
}

class Support {
  Support({required this.url, required this.text});

  final String url;
  final String text;

  factory Support.fromJson(Map<String, dynamic> json) => Support(url: json["url"] ?? '', text: json["text"] ?? '');

  Map<String, dynamic> toJson() => {"url": url, "text": text};
}
