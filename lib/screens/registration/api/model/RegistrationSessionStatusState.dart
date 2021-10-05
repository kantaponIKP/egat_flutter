enum RestRegistrationSessionStatus {
  RequireEmail,
  RequirePhoneNumber,
  Success,
}

extension RestRegistrationSessionStatusExtension on RestRegistrationSessionStatus {
  String get text {
    switch (this) {
      case RestRegistrationSessionStatus.RequireEmail:
        return "REQUIRE_EMAIL";
      case RestRegistrationSessionStatus.RequirePhoneNumber:
        return "REQUIRE_PHONENUMBER";
      case RestRegistrationSessionStatus.Success:
        return "SUCCESS";
    }
  }
}

class RestRegistrationSessionStatuses {
  static RestRegistrationSessionStatus fromText(String text) {
    switch (text) {
      case "REQUIRE_EMAIL":
        return RestRegistrationSessionStatus.RequireEmail;
      case "REQUIRE_PHONENUMBER":
        return RestRegistrationSessionStatus.RequirePhoneNumber;
      case "SUCCESS":
        return RestRegistrationSessionStatus.Success;
      default:
        throw new ArgumentError("Unknown RegistrationSessionStatusState");
    }
  }
}
