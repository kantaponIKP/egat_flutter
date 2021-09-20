enum RestRegistrationStatus {
  RequireCardInfo,
  RequireEkyc,
  RequireOtp,
  RequirePassword,
  Success,
}

extension RestRegistrationStatusExtension on RestRegistrationStatus {
  String get text {
    switch (this) {
      case RestRegistrationStatus.RequireCardInfo:
        return "REQUIRE_CARD_INFO";
      case RestRegistrationStatus.RequireEkyc:
        return "REQUIRE_EKYC";
      case RestRegistrationStatus.RequireOtp:
        return "REQUIRE_OTP";
      case RestRegistrationStatus.RequirePassword:
        return "REQUIRE_PASSWORD";
      case RestRegistrationStatus.Success:
        return "SUCCESS";
    }
  }
}

class RestRegistrationStatuses {
  static RestRegistrationStatus fromText(String text) {
    switch (text) {
      case "REQUIRE_CARD_INFO":
        return RestRegistrationStatus.RequireCardInfo;
      case "REQUIRE_EKYC":
        return RestRegistrationStatus.RequireEkyc;
      case "REQUIRE_OTP":
        return RestRegistrationStatus.RequireOtp;
      case "REQUIRE_PASSWORD":
        return RestRegistrationStatus.RequirePassword;
      case "SUCCESS":
        return RestRegistrationStatus.Success;
      default:
        throw new ArgumentError("Unknown RegistrationStatusState");
    }
  }
}
