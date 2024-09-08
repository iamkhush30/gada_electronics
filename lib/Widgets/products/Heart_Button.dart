import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gadaelectronics_user/Providers/whishlist_provider.dart';
import 'package:provider/provider.dart';

import '../../Providers/Products_Providers.dart';

class HeartButton extends StatefulWidget
{
  const HeartButton({super.key,this.bkgColor = Colors.transparent,this.size = 20,required this.productId,this.isInWishlist=false});
  final Color bkgColor;
  final double size;
  final String productId;
  final bool? isInWishlist;
  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: widget.bkgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: ()async{
          if(wishlistProvider.isProdinWishList(productId: widget.productId))
          {
            return ;
          }
          else{
            setState(() {
              wishlistProvider.addtowhishlist(productId: widget.productId,context: context);
              log("wishlist map ${wishlistProvider.getWishLists}" as num);
            });
          }
        },
        icon: Icon(
          wishlistProvider.isProdinWishList(productId: widget.productId)? IconlyBold.heart : IconlyLight.heart,
          size: widget.size,
          color: wishlistProvider.isProdinWishList(productId: widget.productId)?Colors.red:Colors.white,
        ),
        style: IconButton.styleFrom(
          elevation: 10,
        ),
      )
    );
  }
}