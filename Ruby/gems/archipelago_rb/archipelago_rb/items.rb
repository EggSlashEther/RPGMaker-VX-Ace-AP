module Archipelago

    class Client

        class ItemsManager
            attr_accessor :received, :index

            def initialize(client)
                @client = client
                @datapackages = {}
                @received = []
                @index = 0
            end

            def import_datapackages(datapackages)
                @datapackages = datapackages if datapackages.is_a?(Hash)
                puts "[ItemsManager import_datapackages] Arg is a #{received_items.class}. Expecting Hash." unless datapackages.is_a?(Hash)
            end

            def import_received_items(received_items)
                @received = received_items if received_items.is_a?(Array)
                puts "[ItemsManager import_received_items] Arg is a #{received_items.class}. Expecting Array." unless received_items.is_a?(Array)
            end

            def import_check_index(check_index)
                @index = check_index if check_index.is_a?(Integer)
                puts "[ItemsManager import_check_index] Check index must be an integer!" unless check_index.is_a?(Integer)
            end

            def name(game_name, id)
                @datapackages[game_name]["item_name_to_id"].each do |item, value|
                    return item if value == id
                end
                return "Unknown Item"
            end

            def id(game_name, item_name)
                return @datapackages[game_name]["item_name_to_id"][item_name]
            rescue
                return "Unknown Item"
            end

            def group(game_name, group_name)
                return @datapackages[game_name]["item_name_groups"][group_name]
            rescue
                return "Unknown Item Group"
            end
        end
    end
end