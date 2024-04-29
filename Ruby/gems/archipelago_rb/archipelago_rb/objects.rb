module Archipelago
    module Objects

        # ----------------------------------
        # MINOR OBJECTS
        # These structures are referenced in other packets but are not packets themselves.
        # ----------------------------------

        # VERSION - This object defines an Archipelago version (i.e. 0.4.5)
        class Version
            attr_reader :major, :minor, :build, :class

            def initialize(major, minor, build)
                @major = major
                @minor = minor
                @build = build
                @class = "Version"
            end

            def self.from_hash(data)
                new(data['major'], data['minor'], data['build'])
            end

            def to_hash
                {
                major: @major,
                minor: @minor,
                build: @build,
                class: @class
                }
            end
        end

        class NetworkPlayer
            attr_reader :team, :slot, :alias, :name

            def initialize(team, slot, player_alias, player_name)
                @team = team
                @slot = slot
                @alias = player_alias
                @name = player_name
            end

            def self.from_hash(data)
                new(data['team'], data['slot'], data['alias'], data['name'])
            end

            def to_hash
                {
                team: @team,
                slot: @slot,
                alias: @alias,
                name: @name
                }
            end
        end

        class NetworkItem
            attr_reader :item, :location, :player, :flags

            def initialize(item, location, player, flags)
                @item = item
                @location = location
                @player = player
                @flags = flags
            end

            def self.from_hash(data)
                new(data['item'], data['location'], data['player'], data['flags'])
            end

            def to_hash
                {
                item: @item,
                location: @location,
                player: @player,
                flags: @flags
                }
            end
        end

        class JSONMessagePart
            #TODO: Add output function to console with color tags
            attr_reader :type, :text, :color, :flags, :player

            def initialize(type:, text: nil, color: nil, flags: nil, player: nil)
                @type = type
                @text = text
                @color = color
                @flags = flags
                @player = player
            end

            def self.from_hash(data)
                new(
                type: data['type'],
                text: data['text'],
                color: data['color'],
                flags: data['flags'],
                player: data['player']
                )
            end

            def to_hash
                {
                type: @type,
                text: @text,
                color: @color,
                flags: @flags,
                player: @player
                }
            end
        end

        class NetworkSlot
            attr_reader :name, :game, :type, :group_members

            def initialize(name, game, type, group_members = [])
                @name = name
                @game = game
                @type = type
                @group_members = group_members
            end

            def self.from_hash(data)
                new(
                data['name'],
                data['game'],
                data['type'],
                data['group_members'] || []  # Populate group_members if available, otherwise use an empty array
                )
            end

            def to_hash
                {
                name: @name,
                game: @game,
                type: @type,  # Convert SlotType enum to string representation
                group_members: @group_members
                }
            end
        end

        class Hint
            attr_reader :receiving_player, :finding_player, :location, :item, :found, :entrance, :item_flags

            def initialize(receiving_player, finding_player, location, item, found, entrance = "", item_flags = 0)
                @receiving_player = receiving_player
                @finding_player = finding_player
                @location = location
                @item = item
                @found = found
                @entrance = entrance
                @item_flags = item_flags
            end

            def self.from_hash(data)
            new(
                data['receiving_player'],
                data['finding_player'],
                data['location'],
                data['item'],
                data['found'],
                data['entrance'] || "",
                data['item_flags'] || 0
            )
            end

            def to_hash
            {
                receiving_player: @receiving_player,
                finding_player: @finding_player,
                location: @location,
                item: @item,
                found: @found,
                entrance: @entrance,
                item_flags: @item_flags
            }
            end
        end

        class DataStorageOperation
            attr_accessor :operation, :value

            def initialize(operation, value)
                @operation = operation
                @value = value
            end

            def to_hash
                {
                    operation: @operation,
                    value: @value
                }
            end
        end
    end
end

def valid_json?(json_string)
  JSON.parse(json_string, quirks_mode: true, valid: true)
  true
rescue JSON::ParserError => e
  false
end
