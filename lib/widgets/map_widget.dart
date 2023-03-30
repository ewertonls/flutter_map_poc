import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    super.key,
    this.onTap,
    this.onExitImmersiveMode,
    this.isImmersiveMode = false,
    this.isProtected = false,
  });

  final void Function()? onTap;
  final void Function()? onExitImmersiveMode;
  final bool isImmersiveMode;
  final bool isProtected;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final exampleLocation = const LatLng(-9.6090982, -35.7006511);
  // não é respeitado no google maps
  // final iconSize = const Size.square(64);

  final activeIconPath = 'assets/device_active.png';
  final inactiveIconPath = 'assets/device_inactive.png';

  Map<String, BitmapDescriptor> markerIcons = {};

  BitmapDescriptor? get deviceImage => widget.isProtected
      ? markerIcons[activeIconPath]
      : markerIcons[inactiveIconPath];

  @override
  void initState() {
    super.initState();
    loadAssetIcon();
  }

  Future<void> loadAssetIcon() async {
    final activeIconData = await rootBundle.load(activeIconPath);
    final inactiveIconData = await rootBundle.load(inactiveIconPath);

    markerIcons[activeIconPath] =
        BitmapDescriptor.fromBytes(activeIconData.buffer.asUint8List());
    markerIcons[inactiveIconPath] =
        BitmapDescriptor.fromBytes(inactiveIconData.buffer.asUint8List());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          zoomGesturesEnabled: false,
          initialCameraPosition:
              CameraPosition(target: exampleLocation, zoom: 16),
          markers: {
            Marker(
              markerId: const MarkerId('deviceicon'),
              icon: deviceImage ?? BitmapDescriptor.defaultMarker,
              position: exampleLocation,
              anchor: const Offset(0.5, 0.5),
              onTap: widget.onTap,
            )
          },
        ),
        Visibility(
          visible: widget.isImmersiveMode,
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                top: mediaQuery.padding.top,
                right: mediaQuery.padding.right,
              ),
              child: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: widget.onExitImmersiveMode,
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.isImmersiveMode,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin:
                  EdgeInsets.fromLTRB(16, 8, 16, 8 + mediaQuery.padding.bottom),
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
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: Colors.grey.shade100,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
