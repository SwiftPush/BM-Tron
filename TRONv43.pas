Program Tron;
//BMTron Remake v4.3
Uses crt;

Var
   temp                                  : char;                //Used for reading in characters
   Dead                                  : boolean;             //If either player is dead
   PlayerPosition  : array [1..2,1..2]   of Integer;            //Player 1,2 Then X,Y position So 2,2 Holds player 2's y position
   PlayerDirection : array [1..2]        of char;               //Current Direction of the player
   PlayerScore     : array [1..2]        of Integer;            //Player 1,2 Current Score
   PlayerName      : array [1..2]        of String;             //Player Names 1,2
   PlayerColor     : array [1..2]        of Integer;            //Player Colors 1,2
   GameBoard       : array [1..80,1..48] of Integer;            //Array of integers, for the gameboard
                                                                // 0 - Blank, 1- Player 1 Trail, 2 - Player 2 Trail, 3 - Wall

//------------------------------------------------------------------------------
procedure drawgameboard;         //Draws the gameboard to the screen
var
   counter:integer;
begin
     textbackground(blue);       //Gameboard Color
     For counter:=1 to 78 do     //Draws along x-axis
     begin
          Gotoxy(Counter+2,3);   //Top line
          Write(' ');
          Gotoxy(Counter+2,48);  //Bottom line
          Write(' ');
     end;
     For counter:=1 to 45 do     //Draws along y-axis
     begin
          gotoxy(3,counter+3);   //Left Line
          Write(' ');
          gotoxy(80,counter+3);  //Right Line
          Write(' ');
     end;
     textbackground(black);
end;
//------------------------------------------------------------------------------
procedure drawbike; //Draws the lightbikes of the players
Var CounterA:Integer;
begin
     For CounterA:=1 to 2 Do
     Begin
          textbackground(PlayerColor[CounterA]);
          gotoxy(PlayerPosition[CounterA,1],PlayerPosition[CounterA,2]);
          write(' ')
     End;

     textbackground(black);
     Gotoxy(1,1);
end;
//------------------------------------------------------------------------------
Procedure Die;  //Events to occour when either player dies
Begin
     Dead:=True;    //Dead variable set to yes
     Textbackground(red);
     Gotoxy(27,2);
     If Gameboard[PlayerPosition[1,1],PlayerPosition[1,2]]=3 Then Begin Writeln(PlayerName[1],' Hits The Wall');                        PlayerScore[2]:=PlayerScore[2]+1; End;
     If Gameboard[PlayerPosition[2,1],PlayerPosition[2,2]]=3 Then Begin Writeln(PlayerName[2],' Hits The Wall');                        PlayerScore[1]:=PlayerScore[1]+1; End;
     If Gameboard[PlayerPosition[1,1],PlayerPosition[1,2]]=1 Then Begin Writeln(PlayerName[1],' Hits His Own Tail');                    PlayerScore[2]:=PlayerScore[2]+1; End;
     If Gameboard[PlayerPosition[2,1],PlayerPosition[2,2]]=1 Then Begin Writeln(PlayerName[2],' Hits ',PlayerName[1],Chr(39),'s Tail'); PlayerScore[1]:=PlayerScore[1]+1; End;
     If Gameboard[PlayerPosition[1,1],PlayerPosition[1,2]]=2 Then Begin Writeln(PlayerName[1],' Hits ',PlayerName[2],Chr(39),'s Tail'); PlayerScore[2]:=PlayerScore[2]+1; End;
     If Gameboard[PlayerPosition[2,1],PlayerPosition[2,2]]=2 Then Begin Writeln(PlayerName[2],' Hits His Own Tail');                    PlayerScore[1]:=PlayerScore[1]+1; End;
     If (PlayerPosition[1,1]=PlayerPosition[2,1]) and (PlayerPosition[1,2]=PlayerPosition[2,2]) Then Begin Writeln('Both Players Hit Each Other');        {Draw}          End;
     Textbackground(black);
End;
//------------------------------------------------------------------------------
Procedure InitialiseGameBoard;
Var
   CounterA, CounterB : integer;
Begin
     For CounterA:=1 to 80 Do
     Begin
          For CounterB:=1 to 48 Do
          Begin
               Gameboard[CounterA,CounterB]:=0; //Sets all values in the entire array to 0
          End;
     End;

     For CounterA:=1 to 48 Do         //Along y-axis
     Begin
          Gameboard[3,CounterA] :=3;  //Left Wall
          Gameboard[80,CounterA]:=3;  //Right Wall
     End;

     For CounterA:=1 to 80 Do         //Along x-axis
     Begin
          Gameboard[CounterA,3] :=3;  //Top Wall
          Gameboard[CounterA,48]:=3;  //Bottom Wall
     End;
End;
//------------------------------------------------------------------------------
Procedure DrawScore;  //Draws the players current scores to the screen
Begin
     Gotoxy(5,2);
     Writeln(PlayerName[1],Chr(39),'s Score : ',PlayerScore[1]);  //Chr(39) Used for apostrophe
     Gotoxy(60,2);
     Writeln(PlayerName[2],Chr(39),'s Score : ',PlayerScore[2]);
End;

Procedure GetUserNamesColours;  //Handles the input of the players names and colors
Var
   //temp : char;
   ColorCounter, PlayerCounter : integer;
Begin
     For PlayerCounter:=1 to 2 Do    //Repeats whole loop for both players
     Begin
          Textcolor(7); //ClrScr;    //Intialising values
          ColorCounter:=1;           //Intialising values
          Repeat
                Gotoxy(5,15);
                Writeln('Player ',playercounter,' Name : _________                                        ');
                //If (Length(PlayerName[PlayerCounter])<10) Then Begin Gotoxy(7,16); Writeln('Player Name Must Be Under 10 Characters'); End;
                Gotoxy(21,15);
                Readln(PlayerName[PlayerCounter]);
          Until Length(PlayerName[PlayerCounter])<10; //There chosen name is less than 10 characters long
          Gotoxy(5,17);
          Writeln('Press <a> and <d> to scroll through colours then press enter to select');
          Repeat
                temp:='0';
                temp:=readkey;
                If (temp='d') and (ColorCounter<127) Then ColorCounter:=ColorCounter+1;
                If (temp='a') and (ColorCounter>1)   Then ColorCounter:=ColorCounter-1;
                textcolor(ColorCounter);
                Gotoxy(21,15);
                Write(PlayerName[PlayerCounter]);
          Until ord(temp)=13;  //Until enter is pressed
          PlayerColor[PlayerCounter]:=ColorCounter;   //Sets the value to the players choice
     End;
     textcolor(7);
End;

Procedure Intro;
Begin
     DrawGameBoard;
     Gotoxy(25,5);
     Writeln('Welcome to BMTron v4.3 by Andy Provan');
     Gotoxy(18,9);
     Writeln('Controls | Player 1 - w,a,s,d | Player 2 - i,j,k,l');
End;


Begin
Readln;
Intro;
GetUserNamesColours;
GotoXY(30,20);
Writeln('Double-Tap <ENTER> to play!!!');
Readln;
Repeat
     Clrscr;
     InitialiseGameBoard; Dead:=False;                                            // Intialises values
     PlayerPosition[1,1]:=10; PlayerPosition[1,2]:=24; PlayerDirection[1]:='d';    // Intialises values
     PlayerPosition[2,1]:=70; PlayerPosition[2,2]:=24; PlayerDirection[2]:='j';   // Intialises values
     DrawGameBoard; DrawBike; DrawScore;                                          // Draws everything

     Repeat
           Temp:=readkey;  //Reads in current keypress
           Case temp of    //Decides whether this is a player 1 or 2 keypress
                'w','W','a','A','s','S','d','D' : PlayerDirection[1]:=temp;
                'i','I','j','J','k','K','l','L' : PlayerDirection[2]:=temp;
           End;
           Repeat
                Gameboard[PlayerPosition[1,1],PlayerPosition[1,2]]:=1;  // Sets where player 1 has been to a "1" in the array
                Gameboard[PlayerPosition[2,1],PlayerPosition[2,2]]:=2;  // Sets where player 2 has been to a "2" in the array

                DrawBike;

                Case PlayerDirection[1] of
                     'w','W' : PlayerPosition[1,2]:=PlayerPosition[1,2]-1;  //Up
                     'a','A' : PlayerPosition[1,1]:=PlayerPosition[1,1]-1;  //Left
                     's','S' : PlayerPosition[1,2]:=PlayerPosition[1,2]+1;  //Down
                     'd','D' : PlayerPosition[1,1]:=PlayerPosition[1,1]+1;  //Right
                End;
                Case PlayerDirection[2] of
                     'i','I' : PlayerPosition[2,2]:=PlayerPosition[2,2]-1;  //Up
                     'j','J' : PlayerPosition[2,1]:=PlayerPosition[2,1]-1;  //Left
                     'k','K' : PlayerPosition[2,2]:=PlayerPosition[2,2]+1;  //Down
                     'l','L' : PlayerPosition[2,1]:=PlayerPosition[2,1]+1;  //Right
                End;

                delay(55); //Slows down game
                If (Gameboard[PlayerPosition[1,1],PlayerPosition[1,2]]>0) or (Gameboard[PlayerPosition[2,1],PlayerPosition[2,2]]>0) Then Die; //If the player is in a square where it is not 1
                If (PlayerPosition[1,1]=PlayerPosition[2,1])              and (PlayerPosition[1,2]=PlayerPosition[2,2])             Then Die; //If both players are in the same place
           Until (Dead=True) or KeyPressed;                                                   //When a key is pressed, exits loop to change direction
      Until (Dead=True);
      Gotoxy(20,49);
      Writeln('Press <ENTER> to play again, or "E" to exit');
      TextColor(Black);    //Hides any player keypresses after players have died
      ReadLn(temp);        //Allows user to exit
      TextColor(7);        //Returns text color to normal
Until temp='E';
end.
