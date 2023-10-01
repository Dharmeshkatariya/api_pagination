class UsersResponse {
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<UserDetails>? data;

  UsersResponse({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.data,
  });

  UsersResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'] as int?;
    perPage = json['per_page'] as int?;
    total = json['total'] as int?;
    totalPages = json['total_pages'] as int?;
    if (json['data'] != null) {
      data = <UserDetails>[];
      json['data'].forEach((v) {
        data!.add(UserDetails.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['page'] = page;
    json['per_page'] = perPage;
    json['total'] = total;
    json['total_pages'] = totalPages;
    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class UserDetails {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;

  UserDetails({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    email = json['email'] as String?;
    firstName = json['first_name'] as String?;
    lastName = json['last_name'] as String?;
    avatar = json['avatar'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['email'] = email;
    json['first_name'] = firstName;
    json['last_name'] = lastName;
    json['avatar'] = avatar;
    return json;
  }
}
