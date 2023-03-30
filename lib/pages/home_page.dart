import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_maps/widgets/map_widget.dart';

import '../app_status.dart';
import 'map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var appStatus = AppStatus.active;

  bool get isAppActive => appStatus == AppStatus.active;

  var isImmersiveMode = false;

  double get mapHeight => isImmersiveMode ? 1 : 0.6;

  ScrollPhysics? get scrollPhysics =>
      isImmersiveMode ? const NeverScrollableScrollPhysics() : null;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: isImmersiveMode
          ? null
          : AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                systemStatusBarContrastEnforced: false,
                systemNavigationBarContrastEnforced: false,
                systemNavigationBarColor: Colors.transparent,
              ),
              backgroundColor: Colors.transparent,
              scrolledUnderElevation: 0,
              elevation: 0,
              centerTitle: true,
              title: Material(
                shape: const StadiumBorder(),
                color: isAppActive
                    ? Colors.lightGreen.shade300
                    : Colors.red.shade200,
                clipBehavior: Clip.antiAlias,
                child: PopupMenuButton(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      appStatus.name,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  onSelected: (value) => setState(() {
                    appStatus = value;
                  }),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: AppStatus.active,
                      child: Text(AppStatus.active.name),
                    ),
                    PopupMenuItem(
                      value: AppStatus.inactive,
                      child: Text(AppStatus.inactive.name),
                    ),
                  ],
                ),
              ),
            ),
      body: CustomScrollView(
        physics: scrollPhysics,
        slivers: [
          SliverToBoxAdapter(
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.fastLinearToSlowEaseIn,
              height: mediaQuery.size.height * mapHeight,
              child: MapWidget(
                isImmersiveMode: isImmersiveMode,
                isProtected: isAppActive,
                onTap: () {
                  // descomente qual versão quiser testar
                  // versão com navegação de rota

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(
                        isProtected: isAppActive,
                      ),
                    ),
                  );

                  // versão de imersão na home

                  // setState(() {
                  //   isImmersiveMode = true;
                  // });
                },
                onExitImmersiveMode: () {
                  setState(() {
                    isImmersiveMode = false;
                  });
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 160,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.purple.shade600,
                borderRadius: BorderRadius.circular(26),
              ),
              alignment: Alignment.center,
              child: Text(
                'Banner',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding:
                EdgeInsets.fromLTRB(16, 0, 16, 16 + mediaQuery.padding.bottom),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                List.generate(
                  5,
                  (index) => Container(
                    height: 144,
                    padding: const EdgeInsets.all(16),
                    margin: index != 0 ? const EdgeInsets.only(top: 16) : null,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    alignment: Alignment.center,
                    child: Text('Card ${index + 1}'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
