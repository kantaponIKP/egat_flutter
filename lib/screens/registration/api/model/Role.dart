enum Role {
  Prosumer,
  Aggregator,
  Consumer,
}

extension RestRoleExtension on Role {
  String get text {
    switch (this) {
      case Role.Prosumer:
        return "PROSUMER";
      case Role.Aggregator:
        return "AGGREGATOR";
      case Role.Consumer:
        return "CONSUMER";
    }
  }
}

class RestRole {
  static Role fromText(String text) {
    switch (text) {
      case "PROSUMER":
        return Role.Prosumer;
      case "AGGREGATOR":
        return Role.Aggregator;
      case "CONSUMER":
        return Role.Consumer;
      default:
        throw new ArgumentError("Unknown Role");
    }
  }
}
