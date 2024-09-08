import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class ProductModel with ChangeNotifier {
  final String productId,
      productTitle,
      productPrice,
      productCategory,
      productDescription,
      productImage,
      productQuantity;
  Timestamp? createdAt;
  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    this.createdAt,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data() as Map<String,dynamic>;

    return ProductModel(
        productId: data["productId"],
        productTitle: data["productTitle"],
        productPrice: data["productPrice"],
        productCategory: data["productCategory"],
        productDescription: data["productDescription"],
        productImage: data["productImage"],
        productQuantity: data["productQuantity"],
        createdAt: data["createdAt"]
    );
  }

  static List<ProductModel> products = [
    // Phones
    ProductModel(
      //101
      productId: const Uuid().v4(),
      productTitle: "Boat Stone 135 Portable Wireless Speaker with 5W RMS Immersive Sound,IPX4 Water Resistance,True Wireless Feature, Up to 11H Total Playtime, Multi-Connectivity Modes With Type C Charging(Soldier Green)",
      productPrice: "₹999.00",
      productCategory: "Speaker",
      productDescription: "• Power - Get ready to be enthralled by the 5W RMS sound on Stone 135 portable wireless speakers."
          "\n\n• True Wireless- It supports TWS functionality meaning you can connect two Stone 135s together and simultaneously play music on both of them for twice the impact."
          "\n\n• Playback- The speaker offers up to a total of 11 hours of playtime per single charge at 80% volume level."
          "\n\n• IP Rating- With a lightweight speaker that offers an IPX4 marked resistance against water and splashes, you can enjoy your playlists across terrains in a carefree and hassle-free way."
          "\n\n• Connectivity- You can enjoy your playlists via multiple connectivity modes namely Bluetooth, FM Mode and TF Card."
          "\n\n• Controls- You can control playback, adjust volume levels, activate default voice assistant, etc., with ease courtesy easy to access controls"
          "\n\n• Calling and Mic- The speaker also supports hands free calling feature as it has a built-in mic as well."
          "\n\n • Note- Kindly remove the sticky translucent film from the bottom of the speaker before you start using it.",
      productImage: "assets/product/speaker/S1.png",
      productQuantity: "10",
    ),
  ];
}
