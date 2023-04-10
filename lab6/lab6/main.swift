//
//  main.swift
//  lab6
//
//  Created by Bartłomiej Szczepaniec on 16/06/2022.
//

import Foundation

class Player {
    var name:String = "Player"
    var usedTries:Int
    init() {
        name = "player1"
        usedTries = 0
    }
    
    // Wybór litery
    func pickLetter() -> String {
        print("Wybierz litere")
        var input = readLine() ?? ""
        while input.count != 1 {
            print("Wpisz jedną literę")
            input = readLine() ?? ""
            
        }
        let letter:String = input
        return letter
    }
}

// Objekt gry
class Game {
    var word:String=""
    var board = [String]()
    var triesLimit:Int
    var player:Player
    var words:[String: [String]] = ["cities":["Paris", "Barcelona", "Gdansk", "Mallorca"], "food":["pizza", "paella", "cheesburger", "potato", "fried chicken"], "filmsAndSeries":["Lord of the Rings", "Star Wars", "Simpsons", "Game of Thrones"]]  // Kategorie
    
    init() {
        word = ""
        triesLimit = 10
        player = Player()
    }
    
    func printBoard() {
        print("Słowo do zgadnięcia: ", terminator: " ")
        for letter in board {
            print(letter, terminator: "")
        }
        print("")
        print("Pozostałe próby: " + String(self.triesLimit - player.usedTries))
    }
    
    func chooseWord() -> String {
        print("Wybierz kategorie: (wpisz odpowiadającą cyfrę)")
        print("1.Miasta ")
        print("2.Jedzenie")
        print("3.Filmy i seriale")
        var categoryNumber = readLine() ?? ""  // wybór kategorii
        while categoryNumber != "1" && categoryNumber != "2" && categoryNumber != "3" {
            print("Wybierz cyfrę z {1,2,3}")
            categoryNumber = readLine() ?? ""
        }
        var category:String
        if categoryNumber == "1" {
            category = "cities"
        }
        else if categoryNumber == "2" {
            category = "food"
        }
        else {
            category = "filmsAndSeries"
        }
        
        let wordsToChooseFrom = words[category]
        let length = wordsToChooseFrom?.count ?? 0
        let randomized = Int.random(in: 0..<length)
        
        return wordsToChooseFrom?[randomized] ?? "???"
    }
    
    func initBoard(){
        self.board = Array(repeating: "_", count: word.count)
        if word.contains(" ") {
            for (index, char) in word.uppercased().enumerated() {
                if String(char) == " " {
                    board[index] = " "
                }
            }
        }
    }
    
    func checkLetter(_ letter:String) -> Bool{
        return self.word.uppercased().contains(letter.uppercased())
    }
    
    func putLetter(_ letter: String) {
        let l = letter.uppercased()
        for (index, char) in word.uppercased().enumerated() {
            if String(char) == l {
                board[index] = l
            }
        }
    }
    
    func checkWin() -> Bool {
        return !board.contains("_")
    }
    
    func chooseDifficulty() {  // Poziomy trudności
        print("Wybierz poziom trudności: (wpisz odpowiadającą cyfrę)")
        print("1.Easy - 15 prób")
        print("2.Medium - 10 prób")
        print("3.Hard - 5 prób")
        var difficulty = readLine() ?? ""
        while difficulty != "1" && difficulty != "2" && difficulty != "3" {
            print("Wybierz cyfrę z {1,2,3}")
            difficulty = readLine() ?? ""
        }
        if difficulty == "1" {
            triesLimit = 15
        }
        else if difficulty == "2" {
            triesLimit = 10
        }
        else {
            triesLimit = 5
        }
        print("")
    }
    
    func startGame() {
        while true {  // pętla gry
            self.word = chooseWord()
            initBoard()
            chooseDifficulty()
            player.usedTries = 0
            
            var won = false  // runda
            while player.usedTries < triesLimit {
                printBoard()
                let chosenLetter = player.pickLetter()
                // Sprawdzenie wybranej litery
                if checkLetter(chosenLetter) {
                    // wstawianie litery w odpowiednie miejsca
                        putLetter(chosenLetter)
                    // sprawdzanie, czy już jest wygrana
                    if checkWin() {
                        won = true
                        break
                    }
                    
                }
                else {
                    player.usedTries += 1
                    print("Nie ma takiej litery w słowie")
                }
                
            }
            if won {
                print("Gratulacje, odgadłeś słowo: " + self.word.uppercased())
            }
            else {
                print("Niestety, skończyły się próby, słowem było: " + self.word.uppercased())
            }
            print("Aby, zagrać ponownie wpisz 1, w przeciwnym wypadku wpisz cokolwiek innego")
            let input = readLine() ?? ""
            if input != "1" {
                break
            }
            print("")
        }
    }
}

var g = Game()
g.startGame()
