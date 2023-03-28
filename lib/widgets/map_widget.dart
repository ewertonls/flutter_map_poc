import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
  final exampleLocation = LatLng(-9.6090982, -35.7006511);
  final iconSize = const Size.square(64);

  String get deviceImage => widget.isProtected
      ? 'assets/device_active.png'
      : 'assets/device_inactive.png';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: exampleLocation,
            zoom: 17,
            interactiveFlags: InteractiveFlag.none,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.home_maps',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: exampleLocation,
                  width: 90,
                  height: 90,
                  builder: (context) {
                    return Tooltip(
                      triggerMode: TooltipTriggerMode.tap,
                      message: 'Bateria 100%',
                      child: InkWell(
                        onTap: widget.onTap,
                        child: Image(image: AssetImage(deviceImage)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
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
