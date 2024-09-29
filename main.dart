import 'package:flutter/material.dart';

void main() {
  runApp(TempConversionApp());
}

class TempConversionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Conversion',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Changed primary color to teal
        scaffoldBackgroundColor: Colors.grey[200], // Light gray background
      ),
      home: TempConverter(),
    );
  }
}

class TempConverter extends StatefulWidget {
  @override
  _TempConverterState createState() => _TempConverterState();
}

class _TempConverterState extends State<TempConverter> {
  bool _isFtoC = true; // Flag to track selected conversion
  TextEditingController _inputController = TextEditingController();
  String _result = '';
  List<String> _history = [];

  // Conversion functions
  double _fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  double _celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  void _convert() {
    setState(() {
      double input = double.tryParse(_inputController.text) ?? 0;
      double convertedTemp = _isFtoC
          ? _fahrenheitToCelsius(input)
          : _celsiusToFahrenheit(input);
      _result = convertedTemp.toStringAsFixed(2);

      // Add to history
      String conversion = _isFtoC
          ? 'F to C: ${input.toStringAsFixed(1)} = $_result'
          : 'C to F: ${input.toStringAsFixed(1)} = $_result';
      _history.add(conversion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background color
      appBar: AppBar(
        title: const Text(
          'Temperature Conversion',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white, // White app bar title for contrast
          ),
        ),
        backgroundColor: Colors.teal, // Teal app bar background
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: orientation == Orientation.portrait
                ? _buildPortraitLayout() // Portrait layout
                : _buildLandscapeLayout(), // Landscape layout
          );
        },
      ),
    );
  }

  // Portrait layout
  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ..._buildCommonLayout(),
        const SizedBox(height: 16.0),
        Expanded(
          child: ListView.builder(
            itemCount: _history.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_history[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  // Landscape layout
  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ..._buildCommonLayout(),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _history.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_history[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper method to avoid duplicating layout code
  List<Widget> _buildCommonLayout() {
    return [
      TextField(
        controller: _inputController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Enter temperature',
          labelStyle: TextStyle(color: Colors.teal), // Teal label text
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal), // Teal border
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal), // Teal focus color
          ),
        ),
      ),
      const SizedBox(height: 16.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Convert from F to C'),
          Radio(
            value: true,
            groupValue: _isFtoC,
            activeColor: Colors.teal, // Teal active color for the radio
            onChanged: (bool? value) {
              setState(() {
                _isFtoC = value!;
              });
            },
          ),
          const Text('Convert from C to F'),
          Radio(
            value: false,
            groupValue: _isFtoC,
            activeColor: Colors.teal, // Teal active color for the radio
            onChanged: (bool? value) {
              setState(() {
                _isFtoC = value!;
              });
            },
          ),
        ],
      ),
      const SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: _convert,
        style: ElevatedButton.styleFrom(
            // Yellow button color
        ),
        child: const Text(
          'Convert',
          style: TextStyle(
            color: Colors.black, // Black text color for button
          ),
        ),
      ),
      const SizedBox(height: 16.0),
      Text(
        _result.isEmpty ? 'Result' : 'Result: $_result',
        style: const TextStyle(
          fontSize: 20,
          color: Colors.teal, // Teal text color for the result
        ),
      ),
    ];
  }
}
