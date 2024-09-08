import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:gadaelectronics_user/models/cart_model.dart';
import 'package:provider/provider.dart';

class OrderedProduct extends StatelessWidget {
  const OrderedProduct({Key? key, required this.productId, required this.qty}) : super(key: key);

  final productId;
  final qty;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProductId(productId);
    final size = MediaQuery.of(context).size;

    if (getCurrProduct == null) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              getCurrProduct.productImage,
              height: size.width*0.3,
              width: size.width*0.3,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              SizedBox(
                width: size.width*0.6,
                child: TitleTextWidget(
                  label: getCurrProduct.productTitle,
                  maxLines: 2,
                  fontsize: 19,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    child: TitleTextWidget(
                      label: "₹${getCurrProduct.productPrice}",
                      fontsize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: size.width*0.15,),
                  Container(
                    child: TitleTextWidget(
                      label: "Qty: $qty",
                      fontsize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
