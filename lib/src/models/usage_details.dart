//{
// "isSuccess": false,
// "rxBytes": 44,
// "txBytes": 30
// "error": null
// }
class UsageDetails {
  bool isSuccess;
  int rxBytes;
  int txBytes;
  String? error;

  UsageDetails({
    required this.isSuccess,
    required this.rxBytes,
    required this.txBytes,
    this.error,
  });

  factory UsageDetails.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return UsageDetails(
          isSuccess: false, rxBytes: 0, txBytes: 0, error: "Unknown error");
    }
    return UsageDetails(
        isSuccess: json["isSuccess"],
        rxBytes: json["rxBytes"],
        txBytes: json["txBytes"],
        error: json["error"]);
  }

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "rxBytes": rxBytes,
        "txBytes": txBytes,
        "error": error,
      };
}
