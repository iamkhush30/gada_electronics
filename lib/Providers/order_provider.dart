import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/Root_Screen.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Order/Order_Screen.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/models/cart_model.dart';
import 'package:gadaelectronics_user/models/order_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class OrderProvider with ChangeNotifier {

  final Map<String, OrderModel> _OrderList = {};

  Map<String, OrderModel> get getOrderList {
    return _OrderList;
  }

  final Map<String, CartModel> _ProductList = {};

  Map<String, CartModel> get getProductList {
    return _ProductList;
  }

  final Map<String, List<CartModel>> _userproducts = {};

  Map<String, List<CartModel>> get getUserProductList {
    return _userproducts;
  }

  final userDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  Future<void> placeOrder({required String addressId,required BuildContext context})async{
    final User? user = _auth.currentUser;
    final cartProvider = Provider.of<CartProvider>(context,listen: false);
    final productProvider = Provider.of<ProductProvider>(context,listen: false);

    if(user==null) {
      MyAppFunction.showErrororWarnig(
          context: context,
          subTitel: "Please Login first",
          fct: (){}
      );
      return;
    }
    final uid = user.uid;
    final orderId = Uuid().v4();


    try{
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final List<CartModel> productsList = cartProvider.getCartItems.values.toList();
      await userDB.doc(uid).update({
        'userOrder': FieldValue.arrayUnion([{
          'orderId': orderId,
          'userId': uid,
          'orderTime': Timestamp.now(),
          'products': productsList.map((cartModel) => {
            'orderId': orderId,
            'cartId': cartModel.cartId,
            'productId': cartModel.productId,
            'quantity': cartModel.quantity,
          }).toList(),
          'addressId': addressId,
          'totalProductQut': cartProvider.getQty(),
          'totalAmount': cartProvider.getTotal(productProvider: productProvider),
        }])
      });
      fetchOrder();
      Fluttertoast.showToast(msg: "Order Has Been Placed");
      Navigator.pushNamed(context, RootScreen.routName);
    } catch(error){
      rethrow;
    }
  }

  Future<void> fetchOrder() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      _OrderList.clear();
      return;
    }

    try {
      final userDoc = await userDB.doc(user.uid).get();
      final data = userDoc.data();

      if (data == null || !data.containsKey('userOrder')) {
        return;
      }

      final userOrders = userDoc.get('userOrder');

      for (final orderData in userOrders) {
        final orderId = orderData['orderId'];
        if (orderId != null) {
          final order = OrderModel(
            orderId: orderId,
            userId: orderData['userId'],
            orderTime: orderData['orderTime'],
            products: orderData['products'],
            addressId: orderData['addressId'],
            totalProductQut: orderData['totalProductQut'],
            totalAmount: (orderData['totalAmount'] as num).toDouble(),
          );

          _OrderList.putIfAbsent(orderId, () => order);
          print("${getOrderList.values.last.products}");

          for (final productMap in order.products) {
            final productId = productMap['productId'];
            final product = CartModel(
              cartId: productMap['cartId'],
              orderId: orderId,
              productId: productId,
              quantity: productMap['quantity'],
            );

            _ProductList.putIfAbsent(productId, () => product);
            print("=====${_ProductList.values.toList()}");

            // Populate userproducts if needed
            if (!_userproducts.containsKey(orderId)) {
              _userproducts[orderId] = [];
            }
            _userproducts[orderId]!.add(product);
          }
        }
      }
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Set<CartModel> getUserProducts(String orderId) {
    try {
      if (_userproducts.containsKey(orderId)) {
        Set<CartModel> uniqueProducts = {};

        // Iterate through each product in the order
        for (CartModel product in _userproducts[orderId]!) {
          // Check if the product already exists in the set of unique products
          if (!uniqueProducts.any((p) => p.cartId == product.cartId)) {
            // If not, add it to the set
            uniqueProducts.add(product);
          }
        }
        return uniqueProducts;
      }
      return {};
    } catch (error) {
      rethrow;
    }
  }


  Future<void> removeUserProduct() async {
    try {
      _userproducts.clear();
    } catch (error) {
      rethrow;
    }
  }
}