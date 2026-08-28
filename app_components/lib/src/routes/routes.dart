import 'package:flutter/material.dart';
import '../pages/alert_page.dart';
import '../pages/avatar_page.dart';
import '../pages/cards_page.dart';
import '../pages/animated_container_page.dart';
import '../pages/count_page.dart';
import '../pages/inputs_page.dart';
import '../pages/slider_page.dart';
import '../pages/list_page.dart';
import '../pages/home_page.dart';


Map<String,WidgetBuilder> getAplicationsRoutes(){
  return <String,WidgetBuilder>{
    "/": (BuildContext context) => const HomePage(),
    "alert":(BuildContext context) => const AlertPage(),
    "avatar":(BuildContext context) => const AvatarPage(),
    "card":(BuildContext context) => const CardsPage(),
    "animatedContainer":(BuildContext context) => const AnimatedContainerPage(),
    "inputs":(BuildContext context) => const InputsPage(),
    "slider":(BuildContext context) => const SliderPage(),
    "list":(BuildContext context) => const ListPage(),
    "count":(BuildContext context) => const CountPage(),
  };
}
