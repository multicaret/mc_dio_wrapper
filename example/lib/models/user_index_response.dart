import 'dart:convert';

import 'package:mc_dio_wrapper/mc_dio_wrapper.dart';

final class UserIndexResponse extends McWrapperBaseResponse<UserIndexDatum> {
  UserIndexResponse({
    required super.data,
    required super.errors,
    required super.message,
    required super.status,
  });

  factory UserIndexResponse.fromJson(Map<String, dynamic> json) {
    return UserIndexResponse(
      data: UserIndexDatum.fromJson(json),
      errors: [],
      message: '',
      status: 200,
    );
  }
}

class UserIndexDatum {
  UserIndexDatum({
    required this.limit,
    required this.skip,
    required this.total,
    required this.users,
  });

  final int limit;
  final int skip;
  final int total;
  final List<User> users;

  factory UserIndexDatum.fromJson(Map<String, dynamic> json) => UserIndexDatum(
        limit: json["limit"],
        skip: json["skip"],
        total: json["total"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "skip": skip,
        "total": total,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class User {
  User({
    required this.address,
    required this.age,
    required this.bank,
    required this.birthDate,
    required this.bloodGroup,
    required this.company,
    required this.crypto,
    required this.ein,
    required this.email,
    required this.eyeColor,
    required this.firstName,
    required this.gender,
    required this.hair,
    required this.height,
    required this.id,
    required this.image,
    required this.ip,
    required this.lastName,
    required this.macAddress,
    required this.maidenName,
    required this.password,
    required this.phone,
    required this.role,
    required this.ssn,
    required this.university,
    required this.userAgent,
    required this.username,
    required this.weight,
  });

  final Address address;
  final int age;
  final Bank bank;
  final String birthDate;
  final String bloodGroup;
  final Company company;
  final Crypto crypto;
  final String ein;
  final String email;
  final String eyeColor;
  final String firstName;
  final Gender gender;
  final Hair hair;
  final double height;
  final int id;
  final String image;
  final String ip;
  final String lastName;
  final String macAddress;
  final String maidenName;
  final String password;
  final String phone;
  final Role role;
  final String ssn;
  final String university;
  final String userAgent;
  final String username;
  final double weight;

  factory User.fromJson(Map<String, dynamic> json) => User(
        address: Address.fromJson(json["address"]),
        age: json["age"],
        bank: Bank.fromJson(json["bank"]),
        birthDate: json["birthDate"],
        bloodGroup: json["bloodGroup"],
        company: Company.fromJson(json["company"]),
        crypto: Crypto.fromJson(json["crypto"]),
        ein: json["ein"],
        email: json["email"],
        eyeColor: json["eyeColor"],
        firstName: json["firstName"],
        gender: genderValues.map[json["gender"]] ?? Gender.MALE,
        hair: Hair.fromJson(json["hair"]),
        height: json["height"].toDouble(),
        id: json["id"],
        image: json["image"],
        ip: json["ip"],
        lastName: json["lastName"],
        macAddress: json["macAddress"],
        maidenName: json["maidenName"],
        password: json["password"],
        phone: json["phone"],
        role: roleValues.map[json["role"]] ?? Role.USER,
        ssn: json["ssn"],
        university: json["university"],
        userAgent: json["userAgent"],
        username: json["username"],
        weight: json["weight"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "age": age,
        "bank": bank.toJson(),
        "birthDate": birthDate,
        "bloodGroup": bloodGroup,
        "company": company.toJson(),
        "crypto": crypto.toJson(),
        "ein": ein,
        "email": email,
        "eyeColor": eyeColor,
        "firstName": firstName,
        "gender": genderValues.reverse[gender],
        "hair": hair.toJson(),
        "height": height,
        "id": id,
        "image": image,
        "ip": ip,
        "lastName": lastName,
        "macAddress": macAddress,
        "maidenName": maidenName,
        "password": password,
        "phone": phone,
        "role": roleValues.reverse[role],
        "ssn": ssn,
        "university": university,
        "userAgent": userAgent,
        "username": username,
        "weight": weight,
      };
}

class Address {
  Address({
    required this.address,
    required this.city,
    required this.coordinates,
    required this.country,
    required this.postalCode,
    required this.state,
    required this.stateCode,
  });

  final String address;
  final String city;
  final Coordinates coordinates;
  final Country country;
  final String postalCode;
  final String state;
  final String stateCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address: json["address"],
        city: json["city"],
        coordinates: Coordinates.fromJson(json["coordinates"]),
        country: countryValues.map[json["country"]] ?? Country.UNITED_STATES,
        postalCode: json["postalCode"],
        state: json["state"],
        stateCode: json["stateCode"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "coordinates": coordinates.toJson(),
        "country": countryValues.reverse[country],
        "postalCode": postalCode,
        "state": state,
        "stateCode": stateCode,
      };
}

class Coordinates {
  Coordinates({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

enum Country { UNITED_STATES }

final EnumValues<Country> countryValues = EnumValues({"United States": Country.UNITED_STATES});

class Bank {
  Bank({
    required this.cardExpire,
    required this.cardNumber,
    required this.cardType,
    required this.currency,
    required this.iban,
  });

  final String cardExpire;
  final String cardNumber;
  final String cardType;
  final String currency;
  final String iban;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        cardExpire: json["cardExpire"],
        cardNumber: json["cardNumber"],
        cardType: json["cardType"],
        currency: json["currency"],
        iban: json["iban"],
      );

  Map<String, dynamic> toJson() => {
        "cardExpire": cardExpire,
        "cardNumber": cardNumber,
        "cardType": cardType,
        "currency": currency,
        "iban": iban,
      };
}

class Company {
  Company({
    required this.address,
    required this.department,
    required this.name,
    required this.title,
  });

  final Address address;
  final String department;
  final String name;
  final String title;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        address: Address.fromJson(json["address"]),
        department: json["department"],
        name: json["name"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "department": department,
        "name": name,
        "title": title,
      };
}

class Crypto {
  Crypto({
    required this.coin,
    required this.network,
    required this.wallet,
  });

  final Coin coin;
  final String network;
  final String wallet;

  factory Crypto.fromJson(Map<String, dynamic> json) => Crypto(
        coin: coinValues.map[json["coin"]] ?? Coin.BITCOIN,
        network: json["network"],
        wallet: json["wallet"],
      );

  Map<String, dynamic> toJson() => {
        "coin": coinValues.reverse[coin],
        "network": network,
        "wallet": wallet,
      };
}

enum Coin { BITCOIN }

final EnumValues<Coin> coinValues = EnumValues({"Bitcoin": Coin.BITCOIN});

enum Network { ETHEREUM_ERC20 }

enum Gender { FEMALE, MALE }

final EnumValues<Gender> genderValues = EnumValues({"female": Gender.FEMALE, "male": Gender.MALE});

class Hair {
  Hair({
    required this.color,
    required this.type,
  });

  final String color;
  final HairType type;

  factory Hair.fromRawJson(String str) => Hair.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hair.fromJson(Map<String, dynamic> json) => Hair(
        color: json["color"],
        type: typeValues.map[json["type"]] ?? HairType.CURLY,
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "type": typeValues.reverse[type],
      };
}

enum HairType { CURLY, STRAIGHT, WAVY, KINKY }

final EnumValues<HairType> typeValues = EnumValues({
  "Curly": HairType.CURLY,
  "Kinky": HairType.KINKY,
  "Straight": HairType.STRAIGHT,
  "Wavy": HairType.WAVY
});

enum Role { ADMIN, MODERATOR, USER }

final EnumValues<Role> roleValues =
    EnumValues({"admin": Role.ADMIN, "moderator": Role.MODERATOR, "user": Role.USER});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map((String k, T v) => MapEntry(v, k));
    return reverseMap ?? {};
  }
}
