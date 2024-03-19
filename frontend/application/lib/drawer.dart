import 'package:application/httpRequests.dart';
import 'package:application/utilities.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatefulWidget {
  final ValueNotifier<bool> isBLEEnabled, isMovementEnabled;
   final Limit limitValues;

  const NavDrawer({Key? key, required this.isBLEEnabled, required this.isMovementEnabled, required this.limitValues}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavDrawer> {
  // local objects state
  bool _isBLEEnabled = false, _isMovementEnabled = true;
  Limit _limitValues = Limit(minTemp: 0, maxTemp: 50, minHum: 0, maxHum: 80);
  
  final List<bool> _isObjectPresent = List.generate(3, (_) => false);
  // default values, the limit when no checkbox is used
  Limit _defaultLimitValues = Limit(minTemp: 0, maxTemp: 50, minHum: 0, maxHum: 80);
  
  // Min/Max values for sensors
  final Set<Limit> _objectLimits = {
    const Limit(minTemp: 5, maxTemp: 30, minHum: 0, maxHum: 70),
    const Limit(minTemp: 5, maxTemp: 15, minHum: 30, maxHum: 80),
    const Limit(minTemp: 0, maxTemp: 50, minHum: 0, maxHum: 90)
  };

  final List<String> _objects = ['Books', 'Food', 'Furniture'];

  @override
  void initState() {
    super.initState();
    _isBLEEnabled = widget.isBLEEnabled.value;
    _isMovementEnabled = widget.isMovementEnabled.value;
    _limitValues = widget.limitValues;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Movement Sensor
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Movement Sensor Options',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),

            // Separator line
            Container(
              height: 1.0,
              color: Colors.grey[400],
            ),

            // Toggles, BLE and Movement
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('BLE proximity'),
                    value: _isBLEEnabled,
                    onChanged: (value) => setState(() {
                      _isBLEEnabled = value;
                      toggleBLE(); // Update BLE state
                    }),
                  ),
                  SwitchListTile(
                    title: const Text('Movement detection'),
                    value: _isMovementEnabled,
                    onChanged: (value) => setState(() {
                      _isMovementEnabled = value;
                      toggleMovement(); // Update movement state
                    }),
                  ),
                ],
              ),
            ),

            // Separator line
            Container(
              height: 1.0,
              color: Colors.grey[400],
            ),

            // Title, Objects in Warehouse with checkbox list
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Objects in Warehouse',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _objects.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(_objects[index]),
                        value: _isObjectPresent[index],
                        onChanged: (value) => setState(() {
                          _isObjectPresent[index] = value!;
                          // Reset the limit to the default value
                          _limitValues = _defaultLimitValues;

                          // For the checked checkboxes, update the max/min limits
                          for (int i = 0; i < _objectLimits.length; i++) {
                            if (_isObjectPresent[i]) {
                              _limitValues = getNewLimit(_objectLimits.elementAt(i), _limitValues);
                            }
                          }
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}