import 'package:flutter/material.dart';
//import 'package:map_view/map_view.dart';

import '../helpers/ensure_visible.dart';
import '../../models/product.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  Uri _staticMapUri;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
//    getStaticMap();
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

//  void getStaticMap() {
//    final StaticMapProvider staticMapProvider =
//        StaticMapProvider('AIzaSyC32f23cFNZdju2oIYFwRbwwyJxeqMGUZY');
//
//    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(
//      [
//        Marker('position', 'Position', 41.40338, 2.17403),
//      ],
//      center: Location(41.40338, 2.17403),
//      width: 500,
//      height: 300,
//      maptype: StaticMapViewType.roadmap,
//    );
//
//    setState(() {
//      _staticMapUri = staticMapUri;
//    });
//  }

  void _updateLocation() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Image.network(_staticMapUri.toString()),
      ],
    );
  }
}