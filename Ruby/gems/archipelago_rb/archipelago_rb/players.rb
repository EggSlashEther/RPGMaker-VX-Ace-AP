module Archipelago

    class Client

        class PlayersManager

            def initialize(client)
                @client = client
            end

            def get(player_id)
                if @client.client_connect_status == ConnectStatus::CONNECTED
                    @client.data.players.each do |player|
                        return player if player["slot"] == player_id
                    end
                else
                    puts "[PlayersManager get] You need an active Archipelago connection to use this!"
                end
            end

            def all
                return @client.data.players
            end

            def method_missing(method_name, *args)
                if @client.client_connect_status == ConnectStatus::CONNECTED 
                    if args.length > 1
                        puts "[PlayersManager #{method_name.to_s}] Too many arguments!"
                    else
                        @client.data.players.each do |player|
                            return player[method_name.to_s] if player["slot"] == args[0]
                        end
                    end
                else
                    puts "[PlayersManager #{method_name.to_s}] You need an active Archipelago connection to use this!"
                end
            end
        end
    end
end