import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<Player>(
      model: Player(),
      child: MaterialApp(
        title: 'Darts',
        theme: ThemeData.dark(),
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Darts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ScopedModelDescendant<Player>(builder: (context, child, model) {
              return Column(children: [
                TextField(
                  decoration: new InputDecoration(labelText: "Max points:"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (text) {
                    if (text.isEmpty) {
                      return;
                    }
                    model.setMax(int.parse(text));
                  },
                ),
                TextField(
                  decoration:
                      new InputDecoration(labelText: "How many players:"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (text) {
                    if (text.isEmpty) {
                      return;
                    }
                    model.setPlayers(int.parse(text));
                  },
                ),
                SizedBox(height: 20,),
                ScopedModelDescendant<Player>(builder: (context, child, model) {
                  return ElevatedButton(
                    onPressed: (){
                      model.reset();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerView()));
                    }, 
                    child: Text("Start")
                  );
                }),
              ]);
            }),
          ],
        ),
      ),
    );
  }
}

class PlayerView extends StatelessWidget {
  const PlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Overzicht(),
      ),
      appBar: AppBar(
        title: ScopedModelDescendant<Player>(
          builder: (context, child, model) {
            return Text("Player " + model.getCurrent().toString());
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: ScopedModelDescendant<Player>(
        builder: (context, child, model) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Needed: " + model.needed().toString(),
                  style: TextStyle(fontSize: 50),
                ),
                Text(
                  "Selected: " + model.getCur().toString(),
                  style: TextStyle(fontSize: 40),
                ),
                Expanded(child: PointView()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PointView extends StatelessWidget {
  const PointView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Player>(builder: (context, child, model) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: 12,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 80,
                        height: 70,
                        child: Card(
                          child: OutlinedButton(
                            child: Text(
                              "Clear",
                              style: TextStyle(fontSize: 40),
                            ),
                            onPressed: () {
                              model.clrCurPoints();
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 80,
                        height: 70,
                        child: Card(
                          child: OutlinedButton(
                            child: Text(
                              "Next",
                              style: TextStyle(fontSize: 40),
                            ),
                            onPressed: () {
                              model.addPoints();
                              if (model.isDone()) {
                                Navigator.pop(context);
                              } else {
                                model.nextPlayer();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (index == 11) {
                return Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 80,
                        height: 70,
                        child: Card(
                          child: OutlinedButton(
                            child: Text(
                              "25",
                              style: TextStyle(fontSize: 40),
                            ),
                            onPressed: () {
                              model.addCurPoints(25);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 80,
                        height: 70,
                        child: Card(
                          child: OutlinedButton(
                            child: Text(
                              "50",
                              style: TextStyle(fontSize: 40),
                            ),
                            onPressed: () {
                              model.addCurPoints(50);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              index -= 1;
              return Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 80,
                      height: 70,
                      child: Card(
                        child: OutlinedButton(
                          child: Text(
                            (index * 2 + 1).toString(),
                            style: TextStyle(fontSize: 40),
                          ),
                          onPressed: () {
                            model.addCurPoints(index * 2 + 1);
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 80,
                      height: 70,
                      child: Card(
                        child: OutlinedButton(
                          child: Text(
                            (index * 2 + 2).toString(),
                            style: TextStyle(fontSize: 40),
                          ),
                          onPressed: () {
                            model.addCurPoints(index * 2 + 2);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      );
    });
  }
}

class Overzicht extends StatelessWidget {
  const Overzicht({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Player>(
      builder: (context, child, model) {
        return ListView.builder(
          itemCount: model.getNumPlayers() + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return new Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text("Target: " + model.getMax().toString(),
                      style: TextStyle(fontSize: 40)),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            }
            index -= 1;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Player " + (index + 1).toString(),
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      model.getPoints(index).toString(),
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}


