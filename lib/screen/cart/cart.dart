import 'package:app_store/consts/colors.dart';
import 'package:app_store/consts/my_icons.dart';
import 'package:app_store/provider/cart_provider.dart';
import 'package:app_store/screen/cart/cart_empty.dart';
import 'package:app_store/screen/cart/cart_full.dart';
import 'package:app_store/services/global_method.dart';
import 'package:app_store/services/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  static String routeName = '/CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  var response;
  Future<void> payWithCard({int amount}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait ....');
    await dialog.show();
    response = await StripeService.payWithNewCard(
        currency: 'USD', amount: amount.toString());
    await dialog.hide();
    print('response : ${response.success}');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration: Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  GlobalMethods globalMethods = GlobalMethods();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: CartEmpty(),
          )
        : Scaffold(
            bottomSheet: checkoutSection(context, cartProvider.totalAmount),
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text('Cart (${cartProvider.getCartItems.length})'),
              actions: [
                IconButton(
                  onPressed: () {
                    globalMethods.showDialogg(
                        'Clear cart!',
                        'Your cart will be cleared!',
                        () => cartProvider.clearCart(),
                        context);
                    //cartProvider.clearCart();
                  },
                  icon: Icon(MyAppIcons.trash),
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                itemCount: cartProvider.getCartItems.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return ChangeNotifierProvider.value(
                    value: cartProvider.getCartItems.values.toList()[index],
                    child: CartFull(
                      productId: cartProvider.getCartItems.keys.toList()[index],
                      // id: cartProvider.getCartItems.values.toList()[index].id,
                      // productId: cartProvider.getCartItems.keys.toList()[index],
                      // price:
                      //     cartProvider.getCartItems.values.toList()[index].price,
                      // title:
                      //     cartProvider.getCartItems.values.toList()[index].title,
                      // imageUrl: cartProvider.getCartItems.values
                      //     .toList()[index]
                      //     .iamgeUrl,
                      // quantity: cartProvider.getCartItems.values
                      //     .toList()[index]
                      //     .quantity,
                    ),
                  );
                },
              ),
            ));
  }

  Widget checkoutSection(BuildContext ctx, double subtotal) {
    final cartProvider = Provider.of<CartProvider>(context);
    var uuid = Uuid();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(colors: [
                    ColorsConsts.gradiendLStart,
                    ColorsConsts.gradiendLEnd,
                  ], stops: [
                    0.0,
                    0.7
                  ]),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      double amountInCents = subtotal * 1000;
                      int integerAmount = (amountInCents / 10).ceil();
                      await payWithCard(amount: integerAmount);
                      if (response.success == true) {
                        User user = _auth.currentUser;
                        final _uid = user.uid;
                        cartProvider.getCartItems
                            .forEach((key, orderValue) async {
                          final orderId = uuid.v4();
                          try {
                            await FirebaseFirestore.instance
                                .collection('order')
                                .doc(orderId)
                                .set({
                              'order_id': orderId,
                              'userId': _uid,
                              'productId': orderValue.productId,
                              'title': orderValue.title,
                              'price': orderValue.price * orderValue.quantity,
                              'imageUrl': orderValue.iamgeUrl,
                              'quantity': orderValue.quantity,
                              'orderDate': Timestamp.now()
                            });
                          } catch (err) {
                            print('error occured $err');
                          }
                        });
                      } else {
                        globalMethods.authErrorHandle(
                            'Please enter your true information', context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Checkout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(ctx).textSelectionColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Text(
              'Total :',
              style: TextStyle(
                  color: Theme.of(ctx).textSelectionColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              'US ${subtotal.toStringAsFixed(3)}',
              //textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
