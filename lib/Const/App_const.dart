import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gadaelectronics_user/Services/Asset_Manager.dart';

import '../models/categories_model.dart';

class AppConst
{
  static const String imageUrl='https://images.unsplash.com/photo-1465572089651-8fde36c892dd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80';
  static const String iphone = 'https://m.media-amazon.com/images/I/81SigpJN1KL._SL1500_.jpg';
  static List<dynamic> bannersImage=[ ("${AssetManager.imgPath}/B1.jpg"),
                                      ("${AssetManager.imgPath}/B2.png"),
                                      ("${AssetManager.imgPath}/B3.png"),
                                      ("${AssetManager.imgPath}/B4.png"),
                                    ];

  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: "Laptop",
      image: AssetManager.laptop,
      name: "Laptop",
    ),
    CategoriesModel(
      id: "Mobiles",
      image: AssetManager.phone,
      name: "Mobiles",
    ),
    CategoriesModel(
      id: "Watch",
      image: AssetManager.watch,
      name: "Watch",
    ),
    CategoriesModel(
      id: "TV",
      image: AssetManager.tv,
      name: "TV",
    ),
    CategoriesModel(
      id: "Fridge",
      image: AssetManager.fridge,
      name: "Fridge",
    ),
    CategoriesModel(
      id: "Speaker",
      image: AssetManager.speaker,
      name: "Speaker",
    ),
    CategoriesModel(
      id: "AC",
      image: AssetManager.ac,
      name: "AC",
    ),
    CategoriesModel(
      id: "Camera",
      image: AssetManager.cam,
      name: "Camera",
    ),
  ];
}


