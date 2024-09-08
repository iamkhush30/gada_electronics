import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gadaelectronics_user/Const/validator.dart';
import 'package:gadaelectronics_user/Providers/address_provider.dart';
import 'package:gadaelectronics_user/Root_Screen.dart';
import 'package:gadaelectronics_user/Widgets/App_Name_Text.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  late final TextEditingController _nameController;
  late final TextEditingController _contactNoController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final FocusNode _nameFocus;
  late final FocusNode _contactNoFocus;
  late final FocusNode _addressFocus;
  late final FocusNode _cityFocus;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState(){
    _nameController = TextEditingController();
    _contactNoController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _nameFocus = FocusNode();
    _contactNoFocus = FocusNode();
    _addressFocus = FocusNode();
    _cityFocus = FocusNode();
    super.initState();
  }
  @override
  void dispose(){
    if(mounted)
    {
      _nameController.dispose();
      _contactNoController.dispose();
      _addressController.dispose();
      _cityController.dispose();
      _nameFocus.dispose();
      _contactNoFocus.dispose();
      _addressFocus.dispose();
      _cityFocus.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: AppNameText(fontSize: 25,),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset("assets/images/A2.png",height: MediaQuery.of(context).size.width*0.4,),
                SizedBox(height: 50,),
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50),)),
                    //borderlands yes or no
                    hintText: "Name",
                    prefixIcon: Icon(
                      IconlyLight.profile,
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    FocusScope.of(context)
                        .requestFocus(_contactNoFocus);
                  },
                  validator: (value) {
                    return MyValidators.displayNamevalidator(value);
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _contactNoController,
                  focusNode: _contactNoFocus,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50),)),
                    //borderlands yes or no
                    hintText: "ContactNo",
                    prefixIcon: Icon(
                      IconlyLight.call,
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    FocusScope.of(context)
                        .requestFocus(_addressFocus);
                  },
                  validator: (value) {
                    return MyValidators.phoneNovalidator(value);
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _addressController,
                  focusNode: _addressFocus,
                  textInputAction: TextInputAction.next,
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50),)),
                    //borderlands yes or no
                    hintText: "Address",
                    prefixIcon: Icon(
                      IconlyLight.home,
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    FocusScope.of(context)
                        .requestFocus(_cityFocus);
                  },
                  validator: (value) {
                    return MyValidators.addressvalidator(value);
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _cityController,
                  focusNode: _cityFocus,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50),)),
                    //borderlands yes or no
                    hintText: "City",
                    prefixIcon: Icon(
                      IconlyLight.location,
                    ),
                  ),
                  onFieldSubmitted: (value) async{
                    if(_formKey.currentState!.validate())
                    {
                      await addressProvider.addNewAddress(
                          name: _nameController.text.trim(),
                          contactNo: _contactNoController.text.trim(),
                          address: _addressController.text.trim(),
                          city: _cityController.text.trim(),
                          context: context
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RootScreen(),));
                    }
                  },
                  validator: (value) {
                    return MyValidators.cityvalidator(value);
                  },
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: kBottomNavigationBarHeight-10,
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shadowColor: Colors.purple,
                      // backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0,),),
                    ),
                    child: const Text("Add Address",style: TextStyle(fontSize: 15,)),
                    onPressed: () async{
                      if(_formKey.currentState!.validate())
                      {
                        await addressProvider.addNewAddress(
                            name: _nameController.text.trim(),
                            contactNo: _contactNoController.text.trim(),
                            address: _addressController.text.trim(),
                            city: _cityController.text.trim(),
                            context: context
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RootScreen(),));
                      }
                    },
                  ),
                ),
              ],
            )
          ),
        ),
      )
    );
  }
}
