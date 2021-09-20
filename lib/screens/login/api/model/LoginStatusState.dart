enum RestLoginStatus {
  RequireEmail,
  RequirePassword,
  Success,
}

extension RestLoginStatusExtension on RestLoginStatus {
  String get text {
    switch (this) {
      case RestLoginStatus.RequireEmail:
        return "REQUIRE_EMAIL";
      case RestLoginStatus.RequirePassword:
        return "REQUIRE_PASSWORD";
      case RestLoginStatus.Success:
        return "SUCCESS";
    }
  }
}

class RestRegistrationStatuses {
  static RestLoginStatus fromText(String text) {
    switch (text) {
      case "REQUIRE_EMAIL":
        return RestLoginStatus.RequireEmail;
      case "REQUIRE_PASSWORD":
        return RestLoginStatus.RequirePassword;
      case "SUCCESS":
        return RestLoginStatus.Success;
      default:
        throw new ArgumentError("Unknown RegistrationStatusState");
    }
  }
}
