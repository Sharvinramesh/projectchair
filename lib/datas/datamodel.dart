import 'package:hive/hive.dart';
part 'datamodel.g.dart';

@HiveType(typeId: 1)
class Userdatamodel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  String? image;

  Userdatamodel(
      {this.id,
      required this.username,
      required this.email,
      required this.password,
      this.image});
}

@HiveType(typeId: 2)
class Categorymodel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String imagepath;

  @HiveField(2)
  String categoryname;

  Categorymodel({required this.imagepath, this.id, required this.categoryname});
}

@HiveType(typeId: 3)
class Productmodel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? image;

  @HiveField(2)
  String ?productname;

  @HiveField(3)
  String? categoryname;

  @HiveField(4)
  String? description;

  @HiveField(5)
  int? sellingrate;

  @HiveField(6)
  int? purchaserate;

  @HiveField(7)
  int? stock;

  

  Productmodel(
      {this.id,
      required this.image,
      required this.productname,
      required this.categoryname,
      required this.description,
      required this.sellingrate,
      required this.purchaserate,
      required this.stock,
     
      });
}




@HiveType(typeId: 4)
class SellProduct {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String sellName;

  @HiveField(2)
  final String sellPhone;

  @HiveField(3)
  final String sellproductname;

  @HiveField(4)
  final String sellPrice;

  @HiveField(5)
 final DateTime? sellDate;

 @HiveField(6)
 final String? sellDiscount;



  SellProduct({
    this.id,
    required this.sellName,
    required this.sellPhone,
    required this.sellproductname,
    required this.sellPrice, 
  required this.sellDate,
 required this.sellDiscount,

  });
}
