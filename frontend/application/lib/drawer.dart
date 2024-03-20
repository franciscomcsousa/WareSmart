import 'package:application/httpRequests.dart';
import 'package:application/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {

  const NavDrawer(
      {Key? key})
      : super(key: key);

  @override
  State<NavDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavDrawer> {

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
  }

  @override
  Widget build(BuildContext context) {
    final BLEEnabledState _isBLEEnabledState = Provider.of<BLEEnabledState>(context);
    final MovementState _isMovementEnabledState = Provider.of<MovementState>(context);
    final ObjectPresentState _isObjectPresentState = Provider.of<ObjectPresentState>(context);

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
                    value: _isBLEEnabledState._isBLEEnabled,
                    onChanged: (value) => setState(() {
                      _isBLEEnabledState._isBLEEnabled = value;
                      toggleBLE(_isBLEEnabledState._isBLEEnabled); // Update BLE state
                    }),
                  ),
                  SwitchListTile(
                    title: const Text('Movement detection'),
                    value: _isMovementEnabledState.isMovementEnabled,
                    onChanged: (value) => setState(() {
                      _isMovementEnabledState.isMovementEnabled = value;
                      toggleMovement(_isMovementEnabledState._isMovementEnabled); // Update movement state
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _objects.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(_objects[index]),
                        value: _isObjectPresentState._isObjectPresent[index],
                        onChanged: (value) => setState(() {
                          _isObjectPresentState._isObjectPresent[index] = value!;
                          // Reset the limit to the default value
                          _isObjectPresentState._limitValues = _defaultLimitValues;

                          // For the checked checkboxes, update the max/min limits
                          for (int i = 0; i < _objectLimits.length; i++) {
                            if (_isObjectPresentState._isObjectPresent[i]) {
                              _isObjectPresentState._limitValues = getNewLimit(_objectLimits.elementAt(i), _isObjectPresentState._limitValues);
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

// functions to notify the change in each state
class BLEEnabledState extends ChangeNotifier {
  bool _isBLEEnabled = false;
  bool get isBLEEnabled => _isBLEEnabled;

  set isBLEEnabled(bool value) {
    _isBLEEnabled = value;
    notifyListeners();
  }
}

class MovementState extends ChangeNotifier {
  bool _isMovementEnabled = false;
  bool get isMovementEnabled => _isMovementEnabled;

  set isMovementEnabled(bool value) {
    _isMovementEnabled = value;
    notifyListeners();
  }
}

class LimitState extends ChangeNotifier {
  bool _isMovementEnabled = false;
  bool get isMovementEnabled => _isMovementEnabled;

  set isMovementEnabled(bool value) {
    _isMovementEnabled = value;
    notifyListeners();
  }
}

class ObjectPresentState extends ChangeNotifier {
  List<bool> _isObjectPresent = List.generate(3, (_) => false);
  Limit _limitValues = Limit(minTemp: 0, maxTemp: 50, minHum: 0, maxHum: 80);
  
  List<bool> get isObjectPresent => _isObjectPresent;
  Limit get limitValues => _limitValues;

  void updateObjectPresent(int index, bool value) {
    _isObjectPresent[index] = value;
    notifyListeners();
  }

  void updateLimitValue(Limit newLimit) {
    _limitValues = newLimit;
    notifyListeners();
  }

}
