class ApiException {
  int code = -1;
  String? msg;

  ApiException.byException(Exception e) {
    this.code = -1;
    this.msg = e.toString();
  }

  ApiException(this.code, this.msg);

  @override
  String toString() {
    return "code: $code ==> error: $msg";
  }
}