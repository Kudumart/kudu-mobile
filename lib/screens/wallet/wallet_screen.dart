import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/advert/advert_model.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../models/user.dart';
import '../../providers/home_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  UserModel? userData;
  bool loading = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadWallet(force: true);
    });
  }

  Future<void> loadWallet({bool force = false,bool showLoader = true}) async {
    final model = Provider.of<HomeViewModel>(context,listen: false);
    var response = await model.fetchProfile(context: context,force: force,showLoader: showLoader);
    //adverts = response;
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (c,result){
        Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: RefreshIndicator(
          onRefresh: () async {
            await loadWallet(force: true,showLoader: false);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Wallet",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              centerTitle: false,
              titleSpacing: 0,
              leading: AppBackButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
                },
              ),
            ),
            body: SafeArea(
              minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 24, UiConstant.horizontalPadding, 10),
              child: Container(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {

              },
              backgroundColor: AppUiColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(360),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
