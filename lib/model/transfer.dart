import 'package:epossa_app/model/basis_dto.dart';

class Transfer extends BasisDTO {
  String sender;
  String receiver;
  double amount;
  String description;

  Transfer(
      id, created_at, this.sender, this.receiver, this.amount, this.description)
      : super(id, created_at);

  @override
  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "created_at": created_at.toString(),
        "sender": sender,
        "receiver": receiver,
        "amount": amount.toString(),
        "description": description,
      };

  Map<String, dynamic> toJsonWithoutId() => {
        "sender": sender,
        "receiver": receiver,
        "amount": amount.toString(),
        "description": description,
      };

  @override
  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      json["id"],
      DateTime.parse(json["created_at"]),
      json["sender"],
      json["receiver"],
      json["amount"],
      json["description"],
    );
  }

  factory Transfer.fromJsonResponse(dynamic json) {
    return Transfer(
      int.parse(json["id"]),
      DateTime.parse(json["created_at"]),
      json["sender"],
      json["receiver"],
      double.parse(json["amount"]),
      json["description"],
    );
  }

  Map<String, dynamic> toMap(Transfer transfer) {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["created_at"] = transfer.created_at.toString();
    params["sender"] = transfer.sender;
    params["receiver"] = transfer.receiver;
    params["amount"] = transfer.amount.toString();
    params["description"] = transfer.description;

    return params;
  }
}
