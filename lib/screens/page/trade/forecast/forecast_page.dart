import 'package:egat_flutter/screens/page/trade/forecast/forecast_screen.dart';
import 'package:egat_flutter/screens/page/trade/forecast/state/forecast_date_state.dart';
import 'package:egat_flutter/screens/page/trade/forecast/state/forecast_selected_date_state.dart';
import 'package:egat_flutter/screens/page/trade/forecast/state/forecast_state.dart';
import 'package:egat_flutter/screens/page/trade/forecast/state/forecast_tradeable_time_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ForecastPage extends StatelessWidget {
  const ForecastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<LoginSession, ForecastState>(
          create: (context) {
            final loginSession =
                Provider.of<LoginSession>(context, listen: false);
            return ForecastState(
              loginSession: loginSession,
            );
          },
          update: (context, value, previous) {
            if (previous != null) {
              previous.setLoginSession(value);
            } else {
              previous = ForecastState(
                loginSession: value,
              );
            }

            return previous;
          },
        ),
        ChangeNotifierProxyProvider<ForecastState, ForecastDateState>(
          create: (context) {
            final forecastState =
                Provider.of<ForecastState>(context, listen: false);
            return forecastState.dateState;
          },
          update: (context, value, previous) {
            // This state do not need to be updated before reassign.
            return value.dateState;
          },
        ),
        ChangeNotifierProxyProvider<ForecastState, ForecastSelectedDateState>(
          create: (context) {
            final forecastState =
                Provider.of<ForecastState>(context, listen: false);
            return forecastState.selectedDateInfo;
          },
          update: (context, value, previous) {
            // This state do not need to be updated before reassign.
            return value.selectedDateInfo;
          },
        ),
        ChangeNotifierProxyProvider<ForecastState, ForecastTradeableTimeState>(
          create: (context) {
            final forecastState =
                Provider.of<ForecastState>(context, listen: false);
            return forecastState.tradeableTime;
          },
          update: (context, value, previous) {
            // This state do not need to be updated before reassign.
            return value.tradeableTime;
          },
        ),
      ],
      child: ForecastScreen(),
    );
  }
}
