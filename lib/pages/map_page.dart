import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_maps/widgets/map_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, this.isProtected = false});

  final bool isProtected;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarColor: Colors.transparent,
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8 + mediaQuery.padding.bottom),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Endereço fulano de tal',
                  style: textTheme.titleMedium
                      ?.copyWith(color: Colors.grey.shade100),
                ),
                Text(
                  'Atualizado há 5 minutos',
                  style: textTheme.labelLarge
                      ?.copyWith(color: Colors.grey.shade100),
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.refresh_rounded,
                color: Colors.grey.shade100,
              ),
            ),
          ],
        ),
      ),
      body: Hero(
        tag: 'deviceblablabla',
        child: Material(child: MapWidget(isProtected: widget.isProtected)),
      ),
    );
  }
}
