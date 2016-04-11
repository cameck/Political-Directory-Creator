require_relative "voter"
require_relative "politicians"

class World

  def initialize
    @politicians = []
    @voters = []
    @class_choices = ["v", "p"]
  end

  #General Methods
  def clear_screen
    system "clear"
  end

  def press_enter
    enter_key = nil
    until enter_key == "\n"
      print "Press ENTER to CONTINUE"
      enter_key = gets
    end
  end

  def exit_process
      clear_screen
      exit_process_choices = ["y", "n"]
      puts "Are you sure you want to exit?"
      exit_choices = check_input("(Y)es or (N)o?", exit_process_choices)
      clear_screen
      exit_choices == "y" ?  exit : main_menu
  end

  def check_input(question, valid_input)
    input = nil
    until valid_input.include?(input)
      puts question
      input = gets.chomp.downcase.strip
    end
    return input
  end

  def check_name(question)
    input = ""
    until input.length > 0
      puts question
      input = gets.chomp.strip
    end
    return input
  end

  def format_name(name)
    name.split(" ").map! {|name| name.capitalize}.join(" ")
  end

  def voter_politics
    politics_choices = ["l", "c", "t", "s", "n"]
    puts "What brand of politics is favored by this voter?"
    politics = check_input("(L)iberal, (C)onservative, (T)ea Party, (S)ocialist or (N)eutral", politics_choices)

    #Change user input into usable string
    politics = case politics
    when "l"
      "Liberal"
    when "c"
      "Conservative"
    when "t"
      "Tea Party"
    when "s"
      "Socialist"
    when "n"
      "Neutral"
    else
      "Neutral"
    end
    return politics
  end

  def politician_party
    puts "What is this politician's party affiliation?"
    party_choices = ["r", "d"]
    party = check_input("(R)epublican or (D)emocrat?", party_choices)

    #Change user input into usable string
    party = case party
    when "r"
      "Republican"
    when "d"
      "Democrat"
    else
      "Sorry something happened... Let's try this again."
      press_enter
      main_menu
    end
    return party
  end

  def update_entry(array, name_to_update)
    result = true

    array.each { |item|

      if item.name == name_to_update
        new_name = check_name("Ok, that's in the database. What would you like to change the name to?")
        new_name = format_name(new_name)
        item.name=(new_name)

        if array == @voters
          politics = voter_politics
          item.politics = politics
          new_politics = item.politics
        else
          party = politician_party
          item.party = party
          new_politics = item.party
        end
        return puts "*#{name_to_update} was changed to #{item.name}: #{new_politics}*"

      else
        result = false
      end
    }

    if !result || array == []
      puts "Sorry that's not in the database"
    end
  end

  #General Program Methods (Welcome, Create, List, Update, Destroy)
  def welcome
    clear_screen
    puts "Welcome to Your Local Political Directory!"
    press_enter
  end

  def main_menu
    clear_screen
    menu_choices = ["c", "l", "u", "d", "e"]
    puts "What would you like to do?"
    input = check_input("(C)reate, (L)ist, (U)pdate, (D)elete or (E)xit program?", menu_choices)

    case input
    when "c"
      create
    when "l"
      list
    when "u"
      update
    when "d"
      destroy
    when "e"
      exit_process
    else
      puts "Sorry something went wrong"
      exit
    end
  end

  def create
    clear_screen

    puts "What would you like to create a directory for?"
    input = check_input("(V)oter or (P)olitician?", @class_choices)

    name = check_name("What is the name?")
    name = format_name(name)

    if input == "v"
      politics = voter_politics
      new_voter = Voter.new(name, politics)
      @voters << new_voter
      puts "You added #{new_voter.name}: #{new_voter.politics} to the directory."
      press_enter

    else
      party = politician_party
      politician = Politician.new(name, party)
      @politicians << politician
      puts "You added #{politician.name}: #{politician.party} to the directory."
      press_enter
    end
    main_menu
  end

  def list
    clear_screen

    puts "Here Are All the Politicians:"
    @politicians.each { |politician|
      puts "#{politician.name}: #{politician.party}"
    }
    puts ""

    puts "Here Are All the Voters:"
    @voters.each { |voter|
      puts "#{voter.name}: #{voter.politics}"
    }
    puts ""

    press_enter
    main_menu
  end

  def update
    #find out if user wants to change voter or politician
    input = check_input("Would you like to update a (V)oter or (P)olitician?", @class_choices)
    #find out who they want to update
    puts person_to_change_str = "Who would you like to update?"
    name_to_update = gets.chomp
    name_to_update = format_name(name_to_update)
    #check if name exists in database, if so update; if not error message
    if input == "v"
      update_entry(@voters, name_to_update)
    else
      update_entry(@politicians, name_to_update)
    end
    press_enter
    main_menu
  end

  def destroy
    input = check_input("Would you like to delete a (V)oter or (P)olitician?", @class_choices)

    puts person_to_delete_str = "Who would you like to delete?"
    name_to_delete = gets.chomp
    name_to_delete = format_name(name_to_delete)

    sureness = check_input("Are you sure?\n(Y)es or (N)o", ["y", "n"])

    deleted = false
    if input == "v" && sureness == "y"
      unless @voters.empty?
        new_voters = @voters.reject! { |voter| voter.name == name_to_delete }
        deleted = !(new_voters.nil?)
      end
    elsif sureness == "n"
      main_menu
    else
      unless @politicians.empty?

        new_politicians = @politicians.reject! { |politician| politician.name == name_to_delete }
        deleted = !(new_politicians.nil?)
      end
    end
    if deleted
      puts "#{name_to_delete} was deleted from the database."
    else
      puts 'Sorry we can\'t delete something that doesn\'t exist ¯\_(ツ)_/¯'
    end
    press_enter
    main_menu
  end
end
