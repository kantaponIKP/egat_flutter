import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'forecast_screen.dart';
import 'state/forecast_date_state.dart';
import 'state/forecast_selected_date_state.dart';
import 'state/forecast_state.dart';
import 'state/forecast_tradeable_time_state.dart';

class ForecastPage extends StatelessWidget {
  const ForecastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<LoginSession, ForecastState>(
          create: (context) {
            return ForecastState();
          },
          update: (context, loginSession, previous) {
            final mainScreenTitleState =
                Provider.of<MainScreenTitleState>(context);

            if (previous == null) {
              previous = ForecastState();
            }

            return previous..setLoginSession(loginSession);
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
        )
      ],
      child: ForecastScreen(),
    );
  }
}
