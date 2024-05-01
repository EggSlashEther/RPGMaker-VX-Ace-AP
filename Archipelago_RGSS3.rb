#==============================================================================
# ** Archipelago_RGSS3
#------------------------------------------------------------------------------
#  All lines of text that start with # are comments and aren't read as code.
#  They'll appear in GREEN in the RPGMaker VX Ace script editor.
#
#  This script uses archipelago_rb to allow RPGMaker VX Ace games to connect
#  to the Archipelago Multiworld System.
#
#  Make sure you read the documentation to learn how this works after you
#  set this up! (LINK HERE)
#
#  Credits:
#  Author: EggSlashEther
#       (contact@eggslashether.com)
#  Tester: Scrungip
#       (Discord: scrungip)
#  Archipelago: All of the wonderful developers, staff and players
#       (https://archipelago.gg/)
#  mkxp: Ancurio + everyone else who made commits over the years
#       (https://github.com/Ancurio/mkxp)
#  mkxp-z: All of the maintainers + Ancurio's Discord server
#       (https://github.com/mkxp-z/mkxp-z)
#==============================================================================
#==============================================================================
# ** SETUP
#------------------------------------------------------------------------------
#  Ignore me! I'm just importing required libraries. Go to CONFIGURATION!
#==============================================================================
#--------------------------------------------------------------------------
# * Add "Ruby" directory to load path and import archipelago_rb
#--------------------------------------------------------------------------
    ruby_directory = File.join(Dir.pwd, "Ruby")

    $:.push(ruby_directory) unless System.is_mac?

    if File.directory?(ruby_directory)
        Dir.glob(File.join(ruby_directory, '**', '*')).each do |path|
            $:.push(path) if File.directory?(path)
        end
    end

    require 'archipelago_rb'
#==============================================================================
# ** CONFIGURATION
#------------------------------------------------------------------------------
#  This section allows you to configure basic facts about the game.
#  For simpler RPGMaker VX Ace games, you shouldn't have to delve deeper than
#  this section.
#==============================================================================
#--------------------------------------------------------------------------
# * Basic Details
#  'game' is the game name as it appears in your APWorld.
#  'items_handling' determines what items this client can handle.
#    * DEFAULT: Archipelago::ItemsHandlingFlags::REMOTE_ALL
#--------------------------------------------------------------------------
    game = "ChecksFinder"
    items_handling = Archipelago::ItemsHandlingFlags::REMOTE_ALL
#--------------------------------------------------------------------------
# * ReceivedItem Methods
#  This hash contains the methods you want to call when this
#  client gets a ReceivedItem of a specific ID. This doesn't have to be
#  restricted to only game items! Here's some examples:
#  22111 => "$game_party.gain_item($data_items[11], 22)", 
#   * Gives 22 of Item ID 11.
#  100..110 => "$game_party.gain_item($data_items[1], 2)",
#   * 100, 101, etc, 110 each give 2 of Item ID 1.
#  10001..10010 => "$game_party.gain_item($data_items[(1..10)], 1)",
#   * 10001 gives 1 of Item ID 1, 10002 gives 1 of Item ID 2, etc, until 10
#   * Ranges made this way must both have the same size!
#  33333 => "$game_party.add_actor(1)"
#   * Adds Actor ID 1 to your party.
#  42069 => "$game_variables[1] += 5"
#   * Adds 5 to the 1st game variable.
#  69420 => "SceneManager.goto(Scene_Gameover)"
#   * Triggers a game over.
#--------------------------------------------------------------------------
    receiveditem_methods = {
        # Put your methods here. See the above comment for expected format.
        # Make sure to put a comma after every entry, except the last! 
    }
#==============================================================================
# ** ADVANCED
#------------------------------------------------------------------------------
#  For more complicated games - or more advanced users - additional options
#  are provided here to further customize how this integration works.
#==============================================================================
#--------------------------------------------------------------------------
# * Advanced Details
#  '$archipelago_data_vars' is a Range of game variable IDs that will store 
#  the expected ReceivedItems index. Choose a range that isn't in use!
#  Must span at least 10 consecutive IDs. Some are reserved for future
#  features.
#    * DEFAULT: 4990..5000
#  'disable_load_autoconnect' determines whether save/load overrides that
#  allow for autoconnecting back to a multiworld when you load a file
#  are active. You should disable this if your game already overrides these
#  methods!
#    * DEFAULT: false
#--------------------------------------------------------------------------
    $archipelago_data_vars = 4990..5000
    disable_load_autoconnect = false
#==============================================================================
# ** CODE
#------------------------------------------------------------------------------
#  The feeble should not proceed past this point. Here be dragons.
#  Notes:
#    * 'archipelago_data_vars' legend:
#      * [0]: Expected ReceivedItems index
#      * [1]: Store connect_info if !disable_load_autoconnect
#      * Others: Reserved for future use
#==============================================================================
#--------------------------------------------------------------------------
# * Method: Get ranges from string
#--------------------------------------------------------------------------
    def get_rng_from_str(string)
        range_regex = /\((\d+)(\.{2,3})(\d+)\)/
        ranges = []

        string.scan(range_regex) do |match|
            start_value = match[0].to_i
            end_value = match[2].to_i
            inclusive = match[1] == '..'
            ranges << (inclusive ? (start_value..end_value) : (start_value...end_value))
        end

        ranges.empty? ? false : ranges
    end
#--------------------------------------------------------------------------
# * Method: Replace all ranges in string with placeholder
#--------------------------------------------------------------------------
    def replace_rng_with_pl(string)
        range_regex = /\((\d+)(\.{2,3})(\d+)\)/
        
        ranges = string.scan(range_regex)
        string = string.gsub(range_regex, "\uFFFC") if ranges.any?

        return string
    end
#--------------------------------------------------------------------------
# * Method: Replace all placeholders in string with integers
#--------------------------------------------------------------------------
    def replace_pl_with_int(string, ints)
        i = -1

        modified_string = string.gsub(/\uFFFC/) do |match|
            i += 1
            ints[i]
        end

        return modified_string
    end
#--------------------------------------------------------------------------
# * Method: Expand ReceivedItem methods into new hash
#--------------------------------------------------------------------------
    def expand_receiveditem_methods(receiveditem_methods)
        expanded_receiveditem_methods = {}

        receiveditem_methods.each do |key, value|
            if key.is_a?(Range)
                ranges = get_rng_from_str(value)
                if ranges
                    modding_string = replace_rng_with_pl(value)
                    key.each_with_index do |v, i|
                        ints_to_add = []
                        ranges.each do |range|
                            ints_to_add.append(range.to_a[i])
                        end
                        modded_string = replace_pl_with_int(modding_string, ints_to_add)
                        expanded_receiveditem_methods[v] = modded_string
                    end
                else
                    key.each do |v|
                        expanded_receiveditem_methods[v] = value
                    end
                end
            else
                expanded_receiveditem_methods[key] = value
            end
        end
        
        return expanded_receiveditem_methods
    end
#--------------------------------------------------------------------------
# * Expand ReceivedItem methods into new hash
#--------------------------------------------------------------------------
    expanded_receiveditem_methods = expand_receiveditem_methods(receiveditem_methods)
#--------------------------------------------------------------------------
# * Initialize Archipelago Client
#--------------------------------------------------------------------------
    $archipelago = Archipelago::Client.new
    $archipelago.connect_info = {
        "hostname" => CFG["Archipelago_Hostname"],
        "port" => CFG["Archipelago_Port"].to_i,
        "game" => game,
        "name" => CFG["Archipelago_Name"],
        "items_handling" => items_handling
    }
#--------------------------------------------------------------------------
# * Override DataManager save/load methods
#--------------------------------------------------------------------------
    if !disable_load_autoconnect
        module DataManager
            def self.save_game(index)
                $game_variables[$archipelago_data_vars.to_a[1]] = Marshal.dump($archipelago.connect_info)
                save_game_without_rescue(index)
            rescue
                delete_save_file(index)
                false
            end

            def self.load_game(index)
                load_game_without_rescue(index)
                $archipelago.connect_info = Marshal.load($game_variables[$archipelago_data_vars.to_a[1]])
                $archipelago.connect
            rescue 
                false
            end
        end
    end
#--------------------------------------------------------------------------
# * Attach RPGMaker-specific listeners
#--------------------------------------------------------------------------
    $archipelago.add_listener("ReceivedItems") do |msg|
        item_counter = msg["index"]

        msg["items"].each do |item|
            if $game_variables[$archipelago_data_vars.to_a[0]] == item_counter
                eval(expanded_receiveditem_methods[item["item"]]) 
                $game_variables[$archipelago_data_vars.to_a[0]] += 1
            end
            item_counter += 1
        end
    end

  
