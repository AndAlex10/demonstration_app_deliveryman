import 'package:aqui_tem_deliveryman/controllers/order.controller.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:aqui_tem_deliveryman/views/home.tab.view.dart';
import 'package:aqui_tem_deliveryman/views/orders/order.new.view.dart';
import 'package:aqui_tem_deliveryman/views/orders/orders.filters.view.dart';
import 'package:aqui_tem_deliveryman/views/user/login.view.dart';
import 'package:aqui_tem_deliveryman/views/widgets/widgets_commons.dart';
import 'package:flutter/material.dart';
import 'package:aqui_tem_deliveryman/views/widgets/customdrawer.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  final _pageController = PageController();
  final _orderController = new OrderController();

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    Future<Null> _executeOrder() async {
      var _controller = new OrderController();
      await _controller.searchOrder(store).then((result) async {
        if (result) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrderNewView()));
        }
      });
    }
    store.listenNotifications(_executeOrder);
    return  PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Scaffold(
                appBar: AppBar(
                  title: Text("É pra Já Delivery",
                      style: TextStyle(color: Colors.white)),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  actions: <Widget>[
                    Container(
                        padding: EdgeInsets.only(right: 8.0),
                        alignment: Alignment.center,
                        child: IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () async {
                                    await _orderController
                                        .refreshData(store)
                                        .then((val) async {
                                      if (!val.success) {
                                        await WidgetsCommons.message(
                                            context, val.message, true);
                                      }
                                    });
                                  }
                                ))
                  ],
                ),
                body: HomeTabView(),
                drawer: CustomDrawer(_pageController),
              ),
              WillPopScope(
                  onWillPop: () async {
                    _pageController.jumpToPage(_pageController.initialPage);
                    return false;
                  },
                  child: Scaffold(
                    drawer: CustomDrawer(_pageController),
                    body: OrdersFiltersView(),
                  )),
              WillPopScope(
                  onWillPop: () async {
                    _pageController.jumpToPage(_pageController.initialPage);
                    return false;
                  },
                  child: Scaffold(
                    drawer: CustomDrawer(_pageController),
                    body: LoginView(true),
                  )),
            ],
          );

  }

  Widget menu(BuildContext context, String title, Widget widget,
      PageController pageController) {
    return WillPopScope(
        onWillPop: () async {
          pageController.jumpToPage(pageController.initialPage);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.white),
            title: Text(title, style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          drawer: CustomDrawer(pageController),
          body: widget,
        ));
  }

}
