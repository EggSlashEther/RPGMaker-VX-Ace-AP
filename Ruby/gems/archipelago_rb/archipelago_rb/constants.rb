module Archipelago

    # ----------------------------------
    # CONSTANTS
    # These structures are just referred to for convenience.
    # ----------------------------------

    # ConnectStatus - The client's connection status to the multiworld.
    module ConnectStatus
        DISCONNECTED = 0
        CONNECTING = 1
        CONNECTED = 2
    end

    # ItemsHandlingFlags - What items should be recieved by the multiworld?
    module ItemsHandlingFlags
        LOCAL_ONLY = 0b000 # Never get any items sent to you.
        REMOTE_DIFFERENT_WORLDS = 0b001 # Get items sent to you from other worlds.
        REMOTE_OWN_WORLD = 0b010 # Get items sent to you from your own world. Requires FROM_OTHER to be set.
        REMOTE_STARTING_INVENTORY = 0b100 # Get items from your starting inventory. Requires FROM_OTHER to be set.
        REMOTE_ALL = 0b111 # Shortcut for FROM_OTHER, FROM_OWN and FROM_STARTING all at once.
    end

    # ClientStatus - What is the state of your client? As seen from the server.
    module ClientStatus
        CLIENT_UNKNOWN = 0 # Who knows?
        CLIENT_CONNECTED = 5 # Client connected but is preparing.
        CLIENT_READY = 10 # Client is ready to play.
        CLIENT_PLAYING = 20 # Client is currently playing.
        CLIENT_GOAL = 30 # Client has reached its goal.
    end

    module SlotType
        SPECTATOR = 0b00
        PLAYER = 0b01
        GROUP = 0b10
    end

    module Permission
        DISABLED = 0b000
        ENABLED = 0b001
        GOAL = 0b010
        AUTO = 0b110
        AUTO_ENABLED = 0b111
    end

    module CreateAsHintMode
        NO_HINT = 0
        HINT_EVERYTHING = 1
        HINT_ONLY_NEW = 2
    end

end