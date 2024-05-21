import 'package:cstore/posm.dart/view_posm_photo.dart';
import 'package:cstore/provider/posm_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'posm.dart/posm_form.dart';
import 'provider/authprovider.dart';
import 'provider/finishprovider.dart';
import 'provider/getstoretables.dart';
import 'provider/journeyprovider.dart';
import 'provider/startvisitprovider.dart';
import 'provider/statusOfQrAndGallery.dart';
import 'provider/tableSlotProvider.dart';
import 'provider/viewphotosProvider.dart';
import 'screens/auth.dart';
import 'widgets/JourneyPlane/journeyPlanScreen.dart';
import 'widgets/activityList/activitylistScreen.dart';
import 'widgets/checkin/checkinScreen.dart';
import 'widgets/dashboard/dashboardScreen.dart';
import 'widgets/dashboard/knowledge.dart';
import 'widgets/dashboard/profile.dart';
import 'widgets/dashboard/target.dart';
import 'widgets/lodingpage.dart';
import 'widgets/signaturepad.dart';
import 'widgets/stcTable/stctablescreen.dart';
import 'widgets/viewphotos.dart/viewphotos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProivder()),
        ChangeNotifierProvider.value(value: JourneyProvider()),
        ChangeNotifierProvider.value(value: StartVisitProvider()),
        ChangeNotifierProvider.value(value: StoreTablesProvider()),
        ChangeNotifierProvider.value(value: TableSlotProvider()),
        ChangeNotifierProvider.value(value: FinishProvider()),
        ChangeNotifierProvider.value(value: ViewPhotosProvider()),
        ChangeNotifierProvider.value(value: StatusOfQrAndGalleryProvider()),
        ChangeNotifierProvider.value(value: PosmProvider())
      ],
      child: Consumer<AuthProivder>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'C Store STC',
          theme: ThemeData(
              useMaterial3: false,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: const Color.fromRGBO(79, 0, 140, 1),
              ),
              fontFamily: "OpenSans"),
          home:
              // PosmForm(),
              auth.isAuth
                  ? DashBoardScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? Scaffold(
                                  body: MyLoadingSpinner(),
                                )
                              : const AuthScreen()),
          routes: {
            AuthScreen.routeName: (context) => AuthScreen(),
            DashBoardScreen.routeName: (context) => DashBoardScreen(),
            Target.routeName: (context) => Target(),
            Profile.routeName: (context) => Profile(),
            Knowledge.routeName: (context) => Knowledge(),
            JourneyPlaneScreen.routeName: (context) => JourneyPlaneScreen(),
            CheckInScreen.routeName: (context) => CheckInScreen(),
            ActivityListScreen.routeName: (context) => ActivityListScreen(),
            STCTableScreen.routeName: (context) => STCTableScreen(),
            MyLoadingSpinner.routeName: (context) => MyLoadingSpinner(),
            ViewPhotos.routeName: (context) => ViewPhotos(),
            SignaturePad.routeName: (context) => SignaturePad(),
            PosmForm.routeName: (context) => PosmForm(),
            ViewPosmPhotos.routeName: (context) => ViewPosmPhotos()
          },
        ),
      ),
    );
  }
}
