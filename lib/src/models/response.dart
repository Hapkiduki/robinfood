class Response {
  bool success;
  String message;
  dynamic body;

  Response({this.success, this.message, this.body});

  Response.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['body'] = this.body;
    return data;
  }
}
