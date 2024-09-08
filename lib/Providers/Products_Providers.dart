import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gadaelectronics_user/models/Product_Model.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier{

  List<ProductModel> products = [];

  List<ProductModel> get getProducts {
    return products;
  }

  ProductModel? findByProductId (String productId){
    if(products.where((element) => element.productId==productId).isEmpty){
      return null;
    }
    return products.firstWhere((element) => element.productId==productId);
  }

  List<ProductModel> findByCategory ({required String categoryName}){
    List<ProductModel> categoryList = products.where((element) => element.productCategory.toLowerCase().contains(categoryName.toLowerCase())).toList();
    return categoryList;
  }
  List<ProductModel> searchQuery ({required String searchText,required List<ProductModel> passedList}){
    List<ProductModel> searchList = passedList.where((element) => element.productTitle.toLowerCase().contains(searchText.toLowerCase())).toList();
    return searchList;
  }

  List<ProductModel> viewedRecentlyProducts = [];

  bool findByProductIdInViewdRecently (String productId){
    if(viewedRecentlyProducts.where((element) => element.productId==productId).isEmpty){
      return true;
    }
    return false;
  }

  List<ProductModel> addViewedRecentlyProduct({required String productId}) {
    ProductModel? viewedProduct = findByProductId(productId);

    if (viewedProduct != null && findByProductIdInViewdRecently(productId)) {
      viewedRecentlyProducts.add(viewedProduct);
      notifyListeners();
    }

    return viewedRecentlyProducts;
  }

  void clearLocalviewedRecentlylist() {
    viewedRecentlyProducts.clear();
    notifyListeners();
  }
  
  final productDB = FirebaseFirestore.instance.collection("products");

  Future<List<ProductModel>> fetchProducts()async{
    try{
      await productDB.orderBy('createdAt',descending: false).get().then((productSnapshot) {
        products.clear();
        for(var element in productSnapshot.docs){
          products.insert(0, ProductModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return products;
    } catch(error){
      rethrow;
    }
  }

  Stream<List<ProductModel>> fetchProductsStream(){
    try{
      return productDB.snapshots().map((snapshot) {
        products.clear();
        for(var element in snapshot.docs){
          products.insert(0, ProductModel.fromFirestore(element));
        }
        return products;
      });
    } catch(error){
      rethrow;
    }
  }

}