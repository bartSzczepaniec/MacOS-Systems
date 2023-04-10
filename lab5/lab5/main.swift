//
//  main.swift
//  lab5
//
//  Created by Bartłomiej Szczepaniec on 22/05/2022.
//
import Foundation

class Player {
    var sign:String
    //var game:Game
    init(_ sign: String) {
        self.sign = sign
        //self.game = game
    }
    func move(_ game: Game) {
        print("Podaj miejsce x i y po spacji:")
        var array = readLine()?.split(separator: " ").map(String.init)
        while((array?.count ?? 0) < 2) {
            print("Podaj 2 koordynaty: x y")
            array = readLine()?.split(separator: " ").map(String.init)
        }
        var x = Int(array?[0] ?? "1") ?? 1
        var y = Int(array?[1] ?? "1") ?? 1
        while x < 1 || y < 1 || x > game.size || y > game.size || game.board[y-1][x-1] != "." {
            print("Niepoprawne koordynaty, wybierz jeszcze raz")
            array = readLine()?.split(separator: " ").map(String.init)
            while((array?.count ?? 0) < 2) {
                print("Podaj 2 koordynaty: x y")
                array = readLine()?.split(separator: " ").map(String.init)
            }
            x = Int(array?[0] ?? "1") ?? 1
            y = Int(array?[1] ?? "1") ?? 1
        }
        game.board[y-1][x-1] = sign
    }
}

class AIplayer: Player {
    
    override func move(_ game: Game) {
        var x = Int.random(in: 0..<game.size)
        var y = Int.random(in: 0..<game.size)
        while game.board[y][x] != "." {
            x = Int.random(in: 0..<game.size)
            y = Int.random(in: 0..<game.size)
        }
        game.board[y][x] = sign
    }
}

class Game {
    var size:Int
    var board = [[String]]()
    var player1:Player
    var player2:Player
    init(_ size: Int) {
        self.size = size
        self.board = [[String]]()
        self.board = Array(repeating: Array(repeating: ".", count: size), count: size)
        player1 = Player("x")
        player2 = AIplayer("o")
    }
    func printGame() {
        print(" ", terminator: " ")
        for i in 1...size {
            print(i, terminator: " ")
        }
        print("[x]")
        for i in 0...size-1 {
            print(i + 1, terminator: " ")
            for j in 0...size-1 {
                print(board[i][j], terminator: " ")
            }
            print(" ")
        }
        print("[y]")
    }
    func startGame() {  // Funkcja z petla gry
        var playagain = true
        while playagain {
            print("Wybierz tryb gry - wpisz odpowiednią cyfre:")
            print("1. Gracz vs Gracz 2. Gracz vs AI")
            let mode = readLine()
            if mode == "1" {
                player1 = Player("x")
                player2 = Player("o")
            }
            else {
                print("Czy chcesz mieć pierwszy ruch?")
                print("Odpowiedz Tak lub Nie")
                let ans = readLine()
                if ans == "Tak" {
                    player1 = Player("x")
                    player2 = AIplayer("o")
                }
                else {
                    player1 = AIplayer("x")
                    player2 = Player("o")
                }
            }
            print("Wybierz rozmiar planszy - wpisz odpowiednią cyfre:")
            print("1.Easy(3x3) 2. Medium(5x5) 3. Hard(7x7)")
            let difficulty = readLine()
            if difficulty == "1" {
                size = 3
                board = Array(repeating: Array(repeating: ".", count: size), count: size)
            }
            else if difficulty == "2" {
                size = 5
                board = Array(repeating: Array(repeating: ".", count: size), count: size)
            }
            else {
                size = 7
                board = Array(repeating: Array(repeating: ".", count: size), count: size)
            }
            var end = false // Game loop
            while !end {
                //print("\u{001B}[2J")
                printGame()
                player1.move(self)
                print("")
                print("")
                //print("\u{001B}[2J")
                printGame()
                if(checkWin(player1.sign)) {
                    end = true
                    print("Wygrywa gracz ze znakiem \(player1.sign)")
                    break
                }
                else if(checkIfFull()){
                    end = true
                    print("Remis")
                    break
                }
                player2.move(self)
                if checkWin(player2.sign) {
                    end = true
                    print("Wygrywa gracz ze znakiem \(player2.sign)")
                    break
                }
                else if checkIfFull() {
                    end = true
                    print("Remis")
                    break
                }
                print("")
                print("")
            }
            print("")
            print("")
            print("Wpisz \"again\", aby zagrać ponownie")
            let answer = readLine()
            if answer != "again" {
                print("Koniec")
                playagain = false
            }
            print("")
            print("")
            clearBoard()
        }
    }
    func checkWin(_ sign: String) -> Bool{
        var diagonal = 0
        var diagonal2 = 0  
        for i in 0...size-1 {
            var vertical = 0
            var horizontal = 0
            for j in 0...size-1 {
                if i == j && board[i][j] == sign {
                    diagonal += 1
                }
                if size - 1 - i == j && board[i][j] == sign {
                    diagonal2 += 1
                }
                if board[i][j] == sign {
                    horizontal += 1
                }
                if board[j][i] == sign {
                    vertical += 1
                }
            }
            if vertical == size || horizontal == size {
                return true
            }
        }
        if diagonal == size {
            return true
        }
        else if diagonal2 == size {
            return true
        }
        else {
            return false
        }
    }
    func checkIfFull() -> Bool {
        for array in board {
            let empty_space = array.contains(".")
            if empty_space {
                return false
            }
        }
        return true
    }
    func clearBoard() {
        for i in 0...size-1 {
            for j in 0...size-1 {
                board[i][j] = "."
            }
        }
    }
}
var game = Game(3)
game.startGame()

