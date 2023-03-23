class ResponseModal{
  ErrorModal? errormodal;
  TokenModal? tokenModal;

  ResponseModal({this.errormodal, this.tokenModal});

  ResponseModal.fromJson(Map<String,dynamic> json){
   errormodal = ErrorModal.fromJson(json['error']);
   tokenModal = TokenModal.fromJson(json['data']);
  }
}

class ErrorModal{
  int? code;
  String? message;
  ErrorModal({this.code,this.message});

  ErrorModal.fromJson(Map<String,dynamic> json){
    code = json['code'];
    message = json['message'];
  }
}

class TokenModal{
  String? new_access_token;
  String? new_refresh_token;

  TokenModal({this.new_access_token, this.new_refresh_token});

  TokenModal.fromJson(Map<String,dynamic> json){
    new_access_token = json['new_access_token'];
    new_refresh_token = json['new_refresh_token'];
  }
}