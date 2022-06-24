import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final PageController _pageController = PageController();

  _savePagePosition(int index) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt('initialIndex', index);
    // print('savePagePosition: $index');
  }

  Future<int> getInitialIndex() async {
    final prefs = await _prefs;
    return prefs.getInt('initialIndex') ?? 0;
  }

  _savePage(int currentIndex) {
    setState(() {
      _savePagePosition(currentIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    getInitialIndex();
  }

  @override
  void dispose() {
     _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _screensList = ['Ekran 1', 'Ekran 2', 'Ekran 3'];

    return FutureBuilder<int>(
        future: getInitialIndex(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return PageView.builder(
              itemBuilder: (context, index) {
                return Scaffold(
                    body: Container(
                  color: Colors.lightBlue,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Text(
                      _screensList[index % _screensList.length],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ));
              },
              controller: PageController(initialPage: snapshot.data),
              onPageChanged: _savePage,
            );
          } else if (snapshot.hasError) {
            return const Icon(Icons.error_outline);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
