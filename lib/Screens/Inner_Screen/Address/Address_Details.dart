import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Providers/address_provider.dart';
import 'package:gadaelectronics_user/Providers/order_provider.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Order/Order_Screen.dart';
import 'package:gadaelectronics_user/models/address_model.dart';
import 'package:provider/provider.dart';

class AddressDetail extends StatefulWidget {
  final int index;
  AddressDetail({super.key,required this.index});
  @override
  State<AddressDetail> createState() => _AddressDetailState();
}

class _AddressDetailState extends State<AddressDetail> {
  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    String addressId = addressProvider.getAddressList.keys.elementAt(widget.index);
    AddressModel addressDetail = addressProvider.getAddressList[addressId]!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/A2.png",height: MediaQuery.of(context).size.width*0.1,width: MediaQuery.of(context).size.width*0.1,),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.5,
                        child:
                        Table(
                          children: [
                            TableRow(
                                children: [
                                  Text("Name:",style: TextStyle(color: Colors.lightBlue,fontSize: 15),),
                                  Text(addressDetail.name,style: TextStyle(color: Colors.grey.shade900),),
                                ]
                            ),

                            TableRow(
                                children: [
                                  Text("Number:",style: TextStyle(color: Colors.lightBlue,fontSize: 15),),
                                  Text(addressDetail.contactNo.toString(),style: TextStyle(color: Colors.grey.shade900),),
                                ]
                            ),

                            TableRow(
                                children: [
                                  Text("Address:",style: TextStyle(color: Colors.lightBlue,fontSize: 15),),
                                  Text(addressDetail.address,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey.shade900),),
                                ]
                            ),

                            TableRow(
                                children: [
                                  Text("City:",style: TextStyle(color: Colors.lightBlue,fontSize: 15),),
                                  Text(addressDetail.city,style: TextStyle(color: Colors.grey.shade900),),
                                ]
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(onPressed: ()async{
                await addressProvider.removeAddressfromFirebase(
                    addressId: addressId,
                    name: addressDetail.name,
                    contactNo: addressDetail.contactNo,
                    address: addressDetail.address,
                    city: addressDetail.city
                );
              }, icon: Icon(Icons.delete,color: Colors.grey.shade900,))
            ],
          ),
        ),
    );
  }
}
