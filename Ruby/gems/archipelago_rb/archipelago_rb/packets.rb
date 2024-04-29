module Archipelago
    module Packets
        # ----------------------------------
        # SERVER PACKETS
        # These packets are only ever sent by the server.
        # ----------------------------------

        # ROOMINFO - This packet is part of the handshake process. Contains information about the multiworld.
        class RoomInfo
            attr_reader :cmd, :password, :games, :tags, :version, :generator_version,
                        :permissions, :hint_cost, :location_check_points, 
                        :datapackage_versions, :datapackage_checksums, :seed_name, :time
        
            def initialize(data)
                parse(data)
            end
        
            def parse(data)
                json_data = JSON.parse(data)[0] # Extract the hash from the array
                @cmd = json_data['cmd']
                @password = json_data['password']
                @games = json_data['games']
                @tags = json_data['tags']
                @version = Objects::Version.from_hash(json_data['version'])
                @generator_version = Objects::Version.from_hash(json_data['generator_version'])
                @permissions = json_data['permissions']
                @hint_cost = json_data['hint_cost']
                @location_check_points = json_data['location_check_points']
                @datapackage_versions = json_data['datapackage_versions']
                @datapackage_checksums = json_data['datapackage_checksums']
                @seed_name = json_data['seed_name']
                @time = json_data['time']
            end
        end

        class ConnectionRefused
            attr_reader :cmd, :errors

            def initialize(data)
                parse(data)
            end

            def parse(data)
                json_data = JSON.parse(data)[0]
                @cmd = json_data['cmd']
                @errors = json_data['errors']
            end
        end

        class Connected
            attr_reader :cmd, :team, :slot, :players, :missing_locations, :checked_locations,
                        :slot_data, :slot_info, :hint_points

            def initialize(data)
                parse(data)
            end

            def parse(data)
                json_data = JSON.parse(data)[0]
                @cmd = json_data['cmd']
                @team = json_data['team']
                @slot = json_data['slot']
                @players = json_data['players'] # Should be NetworkPlayer object.
                @missing_locations = json_data['missing_locations']
                @checked_locations = json_data['checked_locations']
                @slot_data = json_data['slot_data']
                @slot_info = json_data['slot_info'] # Should be NetworkSlot object.
                @hint_points = json_data['hint_points']
            end
        end

        class ReceivedItems
            attr_reader :cmd, :index, :items
          
            def initialize(data)
                parse(data)
            end
          
            def parse(data)
                json_data = JSON.parse(data)[0]
                @cmd = json_data['cmd']
                @index = json_data['index']
                @items = json_data['items'] # Should be NetworkItem object.
            end
        end

        class LocationInfo
            attr_reader :cmd, :locations
          
            def initialize(data)
                parse(data)
            end
          
            def parse(data)
                json_data = JSON.parse(data)[0]
                @cmd = json_data['cmd']
                @locations = json_data['locations'] # Should be NetworkItem object.
            end
        end

        class RoomUpdate
            # NOTE: Class should never be initialized. Reserved for future use if need be.
            # Call data.import_game_data(RoomUpdate) instead, with RoomUpdate being a hash.
        end

        class PrintJSON
            attr_reader :cmd, :data, :type, :receiving, :item, :found, :team, :slot, :message, :tags, :countdown
          
            def initialize(data)
                parse(data)
            end
          
            def parse(data)
                json_data = JSON.parse(data)[0]
                @cmd = json_data['cmd']
                @data = json_data['data']
                @type = json_data['type']
                @receiving = json_data['receiving']
                @item = json_data['item']
                @found = json_data['found']
                @team = json_data['team']
                @slot = json_data['slot']
                @message = json_data['message']
                @tags = json_data['tags']
                @countdown = json_data['countdown']
            end

            # TODO: Add string constructor method
        end
          
          
        class DataPackage
            attr_reader :cmd, :data

            def initialize(data)
                parse(data)
            end

            def parse(data)
                json_data = JSON.parse(data)[0]
                @cmd = json_data['cmd']
                @data = json_data['data']
            end
        end

        class Bounced
            attr_reader :cmd, :games, :slots, :tags, :data
          
            def initialize(data)
                parse(data)
            end
          
            def parse(data)
                json_data = JSON.parse(data)[0]
                @cmd = json_data['cmd']
                @games = json_data['games']
                @slots = json_data['slots']
                @tags = json_data['tags']
                @data = json_data['data']
            end
        end

        class InvalidPacket
            attr_reader :cmd, :type, :original_cmd, :text
          
            def initialize(data)
                parse(data)
            end
          
            def parse(data)
                json_data = JSON.parse(data)[0]
                @cmd = json_data['cmd']
                @type = json_data['type']
                @original_cmd = json_data['original_cmd']
                @text = json_data['text']
            end
        end
          
        class Retrieved
            attr_reader :cmd, :keys

            def initialize(data)
                parse(data)
            end

            def parse(data)
                json_data = JSON.parse(data)[0]
                @cmd = json_data['cmd']
                @keys = json_data['keys']
            end
        end

        class SetReply
            attr_reader :cmd, :key, :value, :original_value
          
            def initialize(data)
                parse(data)
            end
          
            def parse(data)
                json_data = JSON.parse(data)[0]
                @cmd = json_data['cmd']
                @key = json_data['key']
                @value = json_data['value']
                @original_value = json_data['original_value']
            end
        end
          
        # TODO: Make all the above packets have relevant methods

        # ----------------------------------
        # CLIENT PACKETS
        # These packets are only ever sent by the client.
        # ----------------------------------

        # CONNECT - This packet is part of the handshake process. Contains information about the client.
        class Connect
            attr_accessor :password, :game, :name, :uuid, :version, :items_handling, :tags, :slot_data
        
            def initialize(password, game, name, uuid, version, items_handling, tags, slot_data)
            @cmd = 'Connect'
            @password = password
            @game = game
            @name = name
            @uuid = uuid
            @version = version.is_a?(Objects::Version) ? version.to_hash : version
            @items_handling = items_handling
            @tags = tags
            @slot_data = slot_data
            end
        
            def to_json(*args)
            [{ 
                cmd: @cmd,
                password: @password,
                game: @game,
                name: @name,
                uuid: @uuid,
                version: @version,
                items_handling: @items_handling,
                tags: @tags,
                slot_data: @slot_data
            }].to_json(*args)
            end  

            # TODO: Add ConnectUpdate method
        end

        class Sync
            
            def initialize
                @cmd = 'Sync'
            end

            def to_json(*args)
            [{
                cmd: @cmd
            }].to_json(*args)
            end

        end

        class LocationChecks
            attr_accessor :locations

            def initialize(locations)
            @cmd = 'LocationChecks'
            @locations = locations # Should be list of ints
            end

            def to_json(*args)
            [{
                cmd: @cmd,
                locations: @locations
            }].to_json(*args)
            end
        end

        class LocationScouts
            attr_accessor :locations, :create_as_hint

            def initialize(create_as_hint, locations)
            @cmd = 'LocationScouts'
            @locations = locations # Should be list of ints
            @create_as_hint = create_as_hint
            end

            def to_json(*args)
            [{
                cmd: @cmd,
                locations: @locations,
                create_as_hint: @create_as_hint
            }].to_json(*args)
            end
        end

        class StatusUpdate
            attr_accessor :status

            def initialize(status)
            @cmd = 'StatusUpdate'
            @status = status
            end

            def to_json(*args)
            [{
                cmd: @cmd,
                status: @status
            }].to_json(*args)
            end
        end

        class Say
            attr_accessor :text

            def initialize(text)
            @cmd = 'Say'
            @text = text
            end

            def to_json(*args)
            [{
                cmd: @cmd,
                text: @text
            }].to_json(*args)
            end
        end

        class GetDataPackage
            attr_accessor :games

            def initialize(games)
                @cmd = "GetDataPackage"
                @games = games
            end

            def to_json(*args)
                [{
                    cmd: @cmd,
                    games: @games                
                }].to_json(*args)
            end
        end

        class Bounce
            attr_accessor :games, :slots, :tags, :data

            def initialize(games, slots, tags, data)
                @cmd = "Bounce"
                @games = games
                @slots = slots
                @tags = tags
                @data = data
            end

            def to_json(*args)
                [{
                    cmd: @cmd,
                    games: @games,
                    slots: @slots,
                    tags: @tags,
                    data: @data
                }].to_json(*args)
            end
        end

        class Get
            attr_accessor :keys

            def initialize(keys)
                @cmd = "Get"
                @keys = keys
            end

            def to_json(*args)
                [{
                    cmd: @cmd,
                    keys: @keys
                }].to_json(*args)
            end
        end

        class Set
            attr_accessor :key, :default, :want_reply, :operations

            def initialize(key, default, want_reply, operations)
                @cmd = "Set"
                @key = key
                @default = default
                @want_reply = want_reply
                @operations = operations
            end

            def to_json(*args)
                [{
                    cmd: @cmd,
                    key: @key,
                    default: @default,
                    want_reply: @want_reply,
                    operations: @operations
                }].to_json(*args)
            end
        end

        class SetNotify
            attr_accessor :keys

            def initialize(keys)
                @cmd = "SetNotify"
                @keys = keys
            end

            def to_json(*args)
                [{
                    cmd: @cmd,
                    keys: @keys
                }].to_json(*args)
            end
        end
    end
end