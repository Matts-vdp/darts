import 'package:scoped_model/scoped_model.dart';

class Player extends Model {
  int maxPoints = 100;
  int currentPlayer = 0;
  int currentPoints = 0;
  List<int> players = [0];

  int getNumPlayers(){
    return players.length;
  }
  
  int getPoints(int i){
    return players[i];
  }

  void addCurPoints(int p){
    currentPoints += p; 
    notifyListeners();
  }
  void clrCurPoints(){
    currentPoints = 0; 
    notifyListeners();
  }
  void addPoints(){
    if (players[currentPlayer] + currentPoints > maxPoints){
      currentPoints = 0;
      return;
    }
    players[currentPlayer] += currentPoints; 
    currentPoints = 0;
    notifyListeners();
  }
  int getCur(){
    return currentPoints;
  }

  int needed() {
    return maxPoints - (getPoints(currentPlayer)+currentPoints);
  }

  int getCurrent(){
    return currentPlayer + 1;
  }

  void nextPlayer(){
    currentPlayer++;
    if (currentPlayer >= players.length){
      currentPlayer = 0;
    }
    if (getPoints(currentPlayer) == maxPoints) {
      nextPlayer();
    }
    else {
      notifyListeners();
    }
  }

  bool isDone(){
    for (int i=0; i<players.length; i++){
      if (getPoints(i) != maxPoints){
        return false;
      }
    }
    return true;
  }

  void reset(){
    setPlayers(players.length);
    currentPlayer = 0;
    currentPoints = 0;
  }

  void setPlayers(int i){
    players.clear();
    for(int a=0; a<i; a++) {
      players.add(0);
    }
  }

  void setMax(int m){
    maxPoints = m;
    notifyListeners();
  }
  int getMax(){
    return maxPoints;
  }
}