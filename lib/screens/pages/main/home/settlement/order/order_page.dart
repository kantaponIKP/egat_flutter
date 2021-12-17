import 'package:egat_flutter/screens/pages/main/home/settlement/order/order_screen.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/order/states/order_selected_date_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'states/order_state.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<LoginSession, OrderState>(
          create: (_) => OrderState(),
          update: (context, loginSession, order) {
            if (order == null) {
              order = OrderState();
            }

            return order..setLoginSession(loginSession);
          },
        ),
        ChangeNotifierProxyProvider<OrderState, OrderSelectedDateState>(
          create: (_) => OrderSelectedDateState(),
          update: (context, order, orderSelectedDate) {
            if (orderSelectedDate == null) {
              orderSelectedDate = OrderSelectedDateState();
            }

            return orderSelectedDate..setOrderState(order);
          },
        ),
      ],
      child: OrderScreen(),
    );
  }
}
