import std.stdio;
import std.string;
import std.math;
import std.algorithm;
import std.array;
import std.conv;
import std.range;

class Player
{
public:
	string name;
	char mark;
	this(string name, char mark)
	{
		this.name = name;
		this.mark = mark;
	}
		char getMark()
	{
		return mark;
	}
	string getName()
	{
		return name;
	}

}

class Game{

Board currentBoard;
static const int nWin = 5; //number of piecies to win

this(Board gameBoard){

currentBoard=gameBoard;

}

	
	bool checkWinner(int r, int c){
	int i,j;
	
		//Horisontal check
		int playerCount = 0;
		for (i = c-(nWin-1); i <= c+(nWin-1); i++) 
    {
    	if (i < 0 || i > currentBoard.size-1) continue;
    	if (currentBoard.board[r][i] == currentBoard.currentPlayer.getMark()) 
    	{
    	    playerCount++;
		}
		else playerCount=0;
		if( playerCount >= nWin ){
			return true;
			break;
			}
		}
		
		//Vertical check
		playerCount = 0;
		 for (i= r-(nWin-1); i <= r+(nWin-1); i++) 
    {
        if (i < 0 || i > currentBoard.size-1) continue;
    	if (currentBoard.board[i][c] == currentBoard.currentPlayer.getMark()) 
    	{
    	    playerCount++;
		}
		else playerCount=0;
		if( playerCount >= nWin ){
			return true;
			break;
			}
			}
		
		
		
		//Diagonal check (left->right)	
		playerCount = 0;
		 for (i = c-(nWin-1), j = r-(nWin-1); i <= c+(nWin-1) && j <= r+(nWin-1); i++, j++) 
    {
	    if (i < 0 || i > currentBoard.size - 1 || j < 0 || j > currentBoard.size - 1) continue; 
    	if (currentBoard.board[j][i] == currentBoard.currentPlayer.getMark()) 
    	{
    	    playerCount++;
			}
			else playerCount=0;
		if( playerCount >= nWin ){
			return true;
			break;
			}
			}
			
				
		//Diagonal check (left<-right)	
		playerCount = 0;
		 for (i = c-(nWin-1), j = r+(nWin-1); i <= c+(nWin-1) && j>=0; i++, j--) 
    {
        if (i < 0 || i > currentBoard.size - 1 || j < 0 || j > currentBoard.size - 1) continue;
    	if (currentBoard.board[j][i] == currentBoard.currentPlayer.getMark()) 
    	{
    	    playerCount++;
		
		}
		else playerCount=0;
		if( playerCount >= nWin ){
			return true;
			break;
			}
		}
		
            
        return false;
		}
		
		bool checkDraw(){
		 for (int i = 0; i < currentBoard.size; i++) {
		    for (int j = 0; j < currentBoard.size; j++) {
            if(currentBoard.board[i][j] == '_')
			return true;
		 }
		}
		return false;
	}	
		
}

class Board
{
public:
	Player currentPlayer;
	static const int size=15; 
	char [size][size] board ;
	

	this(Player beginningPlayer)
	{
		
		 for (int i = 0; i < size; i++) {
		    for (int j = 0; j < size; j++) {
            board[i][j] = '_';
					
        }
		currentPlayer = beginningPlayer;
	}
	}

    void changePlayer(Player firstPlayer, Player secondPlayer ) {
			if (this.currentPlayer == firstPlayer)
				this.currentPlayer = secondPlayer;
			else
				this.currentPlayer = firstPlayer;
		}

	void printBoard() {
	char asciiCol='A';
	char asciiRow='a';
		write("  ");
		for (int i = 0; i < size; i++){
			write(" ");write(asciiCol);
			asciiCol++;	
			}
		write("\n");
		
		for (int i = 0; i < size; i++)
		{
			write(asciiRow);
			asciiRow++;
			write(" ");
			for (int k = 0; k < size; k++){
			write(char(179));write(board[i][k]);
			}
			writeln(char(179));
			//writeln("  -------------------------------");
		}
	}
	
	bool checkPosition(int row, int col)
	{
		if (row >= size || row < 0 || col >= size || col < 0)
			return false;
		if (board[row][col] == '_')
			return true;
		else
			return false;
	}
	
	bool updateBoard(int r, int c)
	{
		if (checkPosition(r, c))
			board[r][c] = currentPlayer.getMark();
		else
			return false;
		return true;
	}
	
	}
	
	int rowValue(char row){
	return cast(int)(row - 97);
	}
	int colValue(char column){
	return cast(int)(column - 65);
	}
	
	void main()
{
    string rc;
	char row, column;
	bool control = true;
	bool winner, draw;

	//string first="First player O", second="Second player X";
	string first,second;
	writeln("Enter first player's name (O player): ");
	readf("%s\n", first);
	writeln("Enter second player's name (X player): ");
	readf("%s\n", second);
    
	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
	Game game=new Game(board);
	
  do
	{
		do
		{
			board.printBoard();
			write("Player:  ");write(board.currentPlayer.getName());write("\n");
			write("Enter row and column (example: jK): ");
			readf("%s\n", rc);
		    if (rc.length==2){
			row=rc[0];
			column=rc[1];
			/*write("Insert row:     ");
			readf("%s\n", row);
			write("Insert column:  ");
			readf("%s\n", column);*/
			control = board.updateBoard(rowValue(row), colValue(column));
			}
			else {
			control=false;
			}
			if (control==false){write("\n");writeln("Enter valid row and column!");}
		
		} while (!control);
		
		winner = game.checkWinner(rowValue(row), colValue(column));
		draw = game.checkDraw();
		
		if (!draw){
		board.printBoard();
		write("\n\nIt's draw!");
		break;
		}
		
		if (!winner)
		{
			board.changePlayer(firstPlayer, secondPlayer);
		}
		else
		{
		board.printBoard();
	    write("\n\nThe winner is: "); write(board.currentPlayer.getName());
	    break;
		}
		
		
		
	} while (!winner);
	
	
	}
	
	unittest {
    //check for horisontal NOT win X
	writeln("TEST check for horisontal NOT win X");
	
   
	
	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);

	auto historyO = ["mM", "lL", "eE", "bK", "mH"];
	auto historyX = ["fF", "fG", "fH", "fI", "fD"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);

	auto winner = game.checkWinner(rowValue(historyX[$-1][0]), colValue(historyX[$-1][1]));
	board.printBoard();
	assert (winner == 0);
}
	
	unittest {
    //check for horisontal win X
	writeln("TEST check for horisontal win X");
	
   
	
	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);

	auto historyO = ["mM", "lL", "eE", "bK", "mH"];
	auto historyX = ["fF", "fG", "fH", "fI", "fJ"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);

	auto winner = game.checkWinner(rowValue(historyX[$-1][0]), colValue(historyX[$-1][1]));
	board.printBoard();
	assert (winner == 1);
}
	unittest {
    //check for horisontal win X
	writeln("TEST check for horisontal win X");
	
   
	
	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);

	auto historyO = ["mM", "lL", "eE", "bK", "mH"];
	auto historyX = ["oB", "oC", "oD", "oE", "oF"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);

	auto winner = game.checkWinner(rowValue(historyX[$-1][0]), colValue(historyX[$-1][1]));
	board.printBoard();
	assert (winner == 1);
}
unittest {
//check for vertical NOT win X 
	writeln("TEST check for vertical NOT win X");

	
	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);


	auto historyO = ["cB", "dB", "eB", "fB", "hB"];
	auto historyX = ["jL", "kL", "lL", "mL", "oL"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);

	auto winner = game.checkWinner(rowValue(historyX[$-1][0]), colValue(historyX[$-1][1]));
	board.printBoard();
	assert (winner == 0);
}
	unittest {
    //check for vertical win X
	writeln("TEST check for vertical win X");

	
	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);

	auto historyO = ["mM", "lL", "eE", "bK", "mH"];
	auto historyX = ["fF", "gF", "hF", "iF", "jF"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);

	auto winner = game.checkWinner(rowValue(historyX[$-1][0]), colValue(historyX[$-1][1]));
	board.printBoard();
	assert (winner == 1);
}
    unittest {
    //check for vertical win X
	writeln("TEST check for vertical win X");

	
	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);

	auto historyO = ["mM", "lL", "eE", "bK", "mH"];
	auto historyX = ["aA", "bA", "cA", "dA", "eA"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);

	auto winner = game.checkWinner(rowValue(historyX[$-1][0]), colValue(historyX[$-1][1]));
	board.printBoard();
	assert (winner == 1);
}
unittest {
//check for diagonal NOT win X (x,y) 
	writeln("TEST check for diagonal NOT win X ");


	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);


	auto historyO = ["jC", "kD", "lE", "mF", "oH"];
	auto historyX = ["bN", "dL", "eK", "fJ", "gI"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);

	auto winner = game.checkWinner(rowValue(historyX[$-1][0]), colValue(historyX[$-1][1]));
	board.printBoard();
	assert (winner == 0);
}
    unittest {
    //check for diagonal win X (x,y)
	writeln("TEST check for diagonal win X (x y)");
   
	
	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);

		auto historyO = ["cD", "fM", "nI", "nB", "kJ"];
	    auto historyX = ["hD", "iE", "jF", "kG", "lH"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);

	auto winner = game.checkWinner(rowValue(historyX[$-1][0]), colValue(historyX[$-1][1]));
	board.printBoard();
	assert (winner == 1);
}
    unittest {
    //check for diagonal win X (x,y)
	writeln("TEST check for diagonal win X (x y)");
   
	
	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);

		auto historyO = ["cD", "fM", "nI", "nB", "kJ"];
	    auto historyX = ["aK", "bL", "cM", "dN", "eO"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);

	auto winner = game.checkWinner(rowValue(historyX[$-1][0]), colValue(historyX[$-1][1]));
	board.printBoard();
	assert (winner == 1);
}

    unittest {
    //check for diagonal win X (x,-y)
	writeln("TEST check for diagonal win X (x -y)");
    
	
	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);

		auto historyO = ["cD", "fM", "nI", "nB", "kJ"];
	    auto historyX = ["bJ", "cI", "dH", "eG", "fF"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);

	auto winner = game.checkWinner(rowValue(historyX[$-1][0]), colValue(historyX[$-1][1]));
	board.printBoard();
	assert (winner == 1);
}
    unittest {
    //check for diagonal win X (x,-y)
	writeln("TEST check for diagonal win X (x -y)");
	
	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);

		auto historyO = ["cD", "fM", "nI", "nB", "kJ"];
	    auto historyX = ["oA", "nB", "mC", "lD", "kE"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);

	auto winner = game.checkWinner(rowValue(historyX[$-1][0]), colValue(historyX[$-1][1]));
	board.printBoard();
	assert (winner == 1);
}


    unittest {
   
	writeln("TEST check for draw");
   
	
	string first="O player", second="X player";	
	Player firstPlayer = new Player(first, 'O');
	Player secondPlayer = new Player(second, 'X');
	Board board = new Board(firstPlayer);
    Game game=new Game(board);

		auto historyO = ["aA", "aC", "aE", "aG", "aI","aK","aM","aO","bB", "bD", "bF", "bH", "bJ","bL","bN","cB", "cD", "cF", "cH", "cJ","cL","cN","dA", "dC", "dE", "dG", "dI","dK","dM","dO","eB", "eD", "eF", "eH", "eJ","eL","eN","fA", "fC", "fE", "fG", "fI","fK","fM","fO","gA", "gC", "gE", "gG", "gI","gK","gM","gO","hB", "hD", "hF", "hH", "hJ","hL","hN","iB", "iD", "iF", "iH", "iJ","iL","iN","jA", "jC", "jE", "jG", "jI","jK","jM","jO","kA", "kC", "kE", "kG", "kI","kK","kM","kO","lB", "lD", "lF", "lH", "lJ","lL","lN","mB", "mD", "mF", "mH", "mJ","mL","mN","nA", "nC", "nE", "nG", "nI","nK","nM","nO","oA", "oC", "oE", "oG", "oI","oK","oM"];
	    auto historyX = ["aB", "aD", "aF", "aH", "aJ","aL","aN","bA","bC", "bE", "bG", "bI", "bK","bM","bO","cA", "cC", "cE", "cG", "cI","cK","cM","cO", "dB", "dD", "dF", "dH","dJ","dL","dN","eA", "eC", "eE", "eG", "eI","eK","eM","eO","fB", "fD", "fF", "fH", "fJ","fL","fN","gB", "gD", "gF", "gH", "gJ","gL","gN","hA","hC", "hE", "hG", "hI", "hK","hM","hO","iA", "iC", "iE", "iG", "iI","iK","iM","iO", "jB", "jD", "jF", "jH","jJ","jL","jN","kB", "kD", "kF", "kH", "kJ","kL","kN","lA","lC", "lE", "lG", "lI", "lK","lM","lO","mA", "mC", "mE", "mG", "mI","mK","mM","mO", "nB", "nD", "nF", "nH","nJ","nL","nN","oB", "oD", "oF", "oH", "oJ","oL","oN"];
	
	foreach (tup; zip(historyO, historyX)) {
		board.updateBoard(rowValue(tup[0][0]), colValue(tup[0][1]));
		board.changePlayer(firstPlayer, secondPlayer);
		board.updateBoard(rowValue(tup[1][0]), colValue(tup[1][1]));
		board.changePlayer(firstPlayer, secondPlayer);
	}
	board.changePlayer(firstPlayer, secondPlayer);
	board.updateBoard(rowValue('o'), colValue('O'));

	auto draw = game.checkDraw();
	board.printBoard();
	assert (draw == 0);
}