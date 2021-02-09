import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:share/share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_size/window_size.dart' as window_size;

import 'package:jokesapp/jokeserver.dart';
import 'package:jokesapp/joke.dart';

// Theme constants
const appName = 'Dad Jokes';

final jokeTextStyle = GoogleFonts.patrickHand(
    textStyle: TextStyle(
        fontFamily: 'Patrick Hand',
        fontSize: 36,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        color: Color(0xFF222222)));

const dadJokesBlue = Color.fromRGBO(3, 62, 140,1.0);

// We store the joke as global state so it can be used in other places. We
// could create a BLoC, but that really seems a little overkill for this
// lightweight app.
Joke theJoke;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isMacOS) {
    window_size.setWindowMinSize(Size(400, 400));
    window_size.setWindowMaxSize(Size(600, 800));
  }
  runApp(DadJokesApp());
}

class DadJokesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: appName,
    theme: ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: dadJokesBlue,
      brightness: Brightness.dark,
      accentColor: Color.fromRGBO(175, 217, 173,1.0),
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      ),
    ),
    home: MainPage(title: appName),
  );
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  Future<Joke> joke;

  @override
  void initState() {
    joke = JokeServer().fetchJoke();
    print(joke.toString());
    super.initState();
  }

  void _refreshAction() {
    setState(() {
      joke = JokeServer().fetchJoke();
    });
  }

  void _aboutAction() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('About Jokes'),
            titleTextStyle: GoogleFonts.poppins(fontSize: 20),
            content:
            Text('Jokes is an App made for CS1300 studio @ Brown University! '
                'Enjoy every variety of the joke here!'),
            contentTextStyle: GoogleFonts.poppins(),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.done),
                label: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _shareAction() {
    Share.share(theJoke.setup);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 62, 140, 1.0),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/title-image1.png',
                fit: BoxFit.fitWidth,
                filterQuality: FilterQuality.high,
                alignment: Alignment.center,
              ),
            ),


            // Expanded(
            //   child: Container(
            //     padding: EdgeInsets.all(5),
            //     child: DecoratedBox(
            //       decoration: ShapeDecoration(
            //         color: Color(0x55FFFFFF),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(8)),
            //         ),
            //       ),
            //       child: Center(
            //         child: DropdownExample()
            //         ),
            //       ),
            //     ),
            //   ),
            // JOKE
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(130, 184, 217, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Center(
                    child: JokeWidget(
                      joke: joke,
                      refreshCallback: _refreshAction,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // NEW JOKE BUTTON
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromRGBO(48, 104, 217,1.0),
        // backgroundColor: Colors.amber,
        onPressed: _refreshAction,
        label: Text(
          'New Joke',
          // style: GoogleFonts.poppins(fontSize: 20),
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
        icon: Icon(Icons.mood, color: Colors.white,),

        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // APP BAR
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.info),
              label: Text('About'),
              onPressed: _aboutAction,
            ),
            if (!Platform.isMacOS)
              FlatButton.icon(
                icon: Icon(Icons.share),
                label: Text('Share'),
                onPressed: _shareAction,
              ),
          ],
        ),
        color: Color.fromRGBO(3, 62, 140,1.0),
      ),
    );
  }
}

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() {
    return _DropdownExampleState();
  }
}

class _DropdownExampleState extends State<DropdownExample> {
  String _value;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        style: TextStyle(color: Colors.deepPurple, fontSize: 24.0),
        items: [
          DropdownMenuItem<String>(
            child: Text('Dark',style: TextStyle(
              color: Colors.white,
            ),),
            value: 'Dark',
          ),
          DropdownMenuItem<String>(
            child: Text('Programming',style: TextStyle(
              color: Colors.white,
            ),),
            value: 'Programming',
          ),
          DropdownMenuItem<String>(
            child: Text('Pun',style: TextStyle(
              color: Colors.white,
            ),),
            value: 'Pun',
          ),
          DropdownMenuItem<String>(
            child: Text('Spooky',style: TextStyle(
              color: Colors.white,
            ),),
            value: 'Spooky',
          ),
          DropdownMenuItem<String>(
            child: Text('Christmas',style: TextStyle(
              color: Colors.white,
            ),),
            value: 'Christmas',
          ),
        ],
        onChanged: (String value) {
          setState(() {
            _value = value;
          });
        },
        hint: Text('Select Item',style: TextStyle(
          color: Colors.white,
        ),),
        value: _value,
        iconSize: 40.0,
        elevation: 16,
        iconEnabledColor: Colors.white,
      ),
    );
  }
}

class JokeWidget extends StatelessWidget {
  final Future<Joke> joke;
  final refreshCallback;

  JokeWidget({Key key, this.joke, this.refreshCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Joke>(
      future: joke,
      builder: (BuildContext context, AsyncSnapshot<Joke> snapshot) {
        // We have a joke
        if (snapshot.hasData && snapshot.data?.error == false) {
          theJoke = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8),
            child: AutoSizeText(
              snapshot.data.setup+" "+snapshot.data.delivery,
              style: jokeTextStyle,
            ),
          );
        }

        // Something went wrong
        else if (snapshot.hasError || snapshot.data?.error == true) {
          return Center(
            child: ListTile(
              leading: Icon(
                Icons.block,
                color: Color(0xFF333333),
              ),
              title: Text(
                'Network error',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              subtitle: Text(
                'Sorry - this isn\'t funny, we know, but our jokes '
                    'come directly from the Internet for maximum freshness. '
                    'We can\'t reach the server: network issues, perhaps?',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
          );
        }

        // We're still just loading
        else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}