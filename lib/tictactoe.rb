require 'colorize'

class Board
    @@cols = [@@col1 = {:a1 => ' ', :b1 => ' ', :c1 => ' '},
              @@col2 = {:a2 => ' ', :b2 => ' ', :c2 => ' '},
              @@col3 = {:a3 => ' ', :b3 => ' ', :c3 => ' '}]
 
    def initialize
        @win = false
        @draw = false
        @@turn = 1
        display
    end

    def display
        puts "===============================".colorize(:light_green) 
        puts "          TIC-TAC-TOE          ".colorize(:light_yellow)
        puts "===============================".colorize(:light_green)
        puts " "
        puts "Entre une lettre A, B ou C "
        puts "Entre un nombre 1, 2 ou 3"
        puts "Exemple: A3"
        puts " "
        drawBoard
    end
    
    def drawBoard
        puts "===============================".colorize(:light_green) 
        puts "           Tour #{@@turn}".colorize(:light_yellow)
        puts "===============================".colorize(:light_green)
        puts " "
        puts "           A   B   C    "
        puts "          -----------  "
        puts "       1 | #{@@col1[:a1]} | #{@@col1[:b1]} | #{@@col1[:c1]} |"
        puts "          -----------  "
        puts "       2 | #{@@col2[:a2]} | #{@@col2[:b2]} | #{@@col2[:c2]} |"
        puts "          -----------  "
        puts "       3 | #{@@col3[:a3]} | #{@@col3[:b3]} | #{@@col3[:c3]} |"
        puts "          -----------  "
        puts " "
    end

    def select(cell)
        @@cols.each do |col|
            col.each do|key, value|
                if key == cell && value == ' '
                    if @@turn.odd? then col[key] = "X" else col[key] = "O"
                    end
                    #si c'est un tour impair tu mets un X
                    @@turn += 1
                end
            end
        end
    end
    
    def check_board
        x_wins = ["X", "X", "X"]
        o_wins = ["O", "O", "O"]

        winning_cols = [            
            [@@col1[:a1],@@col2[:a2],@@col3[:a3]],
            [@@col1[:b1],@@col2[:b2],@@col3[:b3]],
            [@@col1[:c1],@@col2[:c2],@@col3[:c3]],
            [@@col1[:a1],@@col1[:b1],@@col1[:c1]],
            [@@col2[:a2],@@col2[:b2],@@col2[:c2]],
            [@@col3[:a3],@@col3[:b3],@@col3[:c3]],
            [@@col1[:a1],@@col2[:b2],@@col3[:c3]],
            [@@col3[:a3],@@col2[:b2],@@col1[:c1]]     
        ]

        winning_cols.each do |match|
            if match == x_wins || match == o_wins
                @win = true
            end
        end

        if @@turn >=9
            @draw = true
            #Tu continues les tours tant qu'on est pas arrivé à 9
        end
    end

    
    def win
        @win
    end  
    
    def draw
        @draw
    end        

end

class Player
    attr_accessor :nom
    def initialize(nom)
        @nom = nom
    end
end

class Game

    def initialize
        @player1 = Player.new(player_name(1))
        @player2 = Player.new(player_name(2))
        @current_player = @player2

        @selected_values = []

        @board = Board.new
        @game_on = true
        play_game
    end
    
    def player_name(num)
        puts "Salut joueur #{num}! Quel est ton nom:"
        gets.chomp
    end

    def again
                puts "Veux tu rejouer? y/n"
                i = gets.chomp.downcase
                @i = i
                    if i == "y"
                        puts "Et c'est reparti !"
                        Game.new
                    else 
                        puts "OK, à la prochaine ! Bisous"
                        exit
                    end
    end

    def play_game
        while @game_on
            puts "===============================".colorize(:light_green) 
            puts "Le match #{@player1.nom} VS #{@player2.nom}".colorize(:light_yellow)
            puts "===============================".colorize(:light_green) 
            puts "C'est ton tour #{@current_player.nom}"
            cell = gets.chomp.to_sym.downcase
            
            # Pour regarder si la cellule est prise ou est vide
            while cell.match(/[^a-c1-3]/) || @selected_values.include?(cell)
                #c'est du c++ pour dire tout ce qui n
                puts "Cette position a déjà été prise ou est invalide! Choisis encore:"
                cell = gets.chomp.to_sym.downcase
            end
            @selected_values << cell

            @board.select(cell)
            @board.drawBoard
            @board.check_board
            if @board.win
                puts "Le vainqueur est #{@current_player.nom}!"
                puts "GAME OVER! Bravo à tous!"
                again

            elsif @board.draw
                puts "C'est une égalité!"
                puts "Vous aurez plus de chance la prochaine fois!"
                again
              
            end
            switch_cur_player
        end
    end

    def switch_cur_player
        @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
    end
end

newGame = Game.new

