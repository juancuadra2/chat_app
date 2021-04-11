import 'dart:convert';

Mensaje mensajeFromJson(String str) => Mensaje.fromJson(json.decode(str));

String mensajeToJson(Mensaje data) => json.encode(data.toJson());

class Mensaje {
    Mensaje({
        this.from,
        this.to,
        this.mensaje,
        this.createdAt,
        this.updatedAt,
    });

    final String from;
    final String to;
    final String mensaje;
    final DateTime createdAt;
    final DateTime updatedAt;

    factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        from: json["from"],
        to: json["to"],
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
