require_relative "../economic_model"

class EconomicModel::Person
  def initialize(name)
    @name = name

    # How many fish must you eat each day to stay alive.
    @daily_appetite = 10

    # Inventory of fish
    @inventory = {
      fish: 0
    }

    # The value is how many of the key this person can get by spending a day
    # collecting/creating the key.
    @skills = {
      fish: 12
    }

    @alive = true
  end

  def status(indent=0)
    indent = " " * indent
    result = []
    result << "Name: #{@name}"
    result << "Alive?: #{alive?}"
    result << "Fish: #{inventory[:fish]}"
    result << "Last Activity: #{@last_activity}"
    result.join("\n#{indent}")
  end

  # Make a day pass
  def continue

    inventory_with_leisure = expected_inventory.dup
    inventory_with_leisure[:leisure] = 1

    inventory_with_fishing = expected_inventory.dup
    # TODO: DRY up this logic with Person#catch_fish
    inventory_with_fishing[:fish] += @skills[:fish]

    #p '@'*88
    #p inventory_with_fishing
    #p rank_potential_inventory(inventory_with_fishing)
    #p '@'*88
    #p inventory_with_leisure
    #p rank_potential_inventory(inventory_with_leisure)
    #p '@'*88
    if rank_potential_inventory(inventory_with_fishing) < rank_potential_inventory(inventory_with_leisure)
      catch_fish
      @last_activity = :catch_fish
    else
      @last_activity = :leisure
    end


    eat # or starve
  end

  private

  def inventory
    @inventory
  end

  # Inventory expected at the end of the day.
  # I.e. the current inventory minus what will be consumed that day.
  def expected_inventory
    result = @inventory.dup
    # TODO DRY this up with `Person#eat`
    result[:fish] -= @daily_appetite = 10
    result
  end

  def alive?
    @alive
  end

  # You must eat every day, otherwise you die.
  def eat
    inventory[:fish] -= @daily_appetite = 10

    if inventory[:fish] < 0
      @alive = false
      inventory[:fish] = 0
    end
  end

  def work(thing_to_produce)
    case thing_to_produce
    when :fish
      catch_fish
    else
      fail "Don't know how to produce #{thing_to_produce.inspect}"
    end
  end

  # Spend time catching fish
  def catch_fish
    inventory[:fish] += @skills[:fish]
  end

  # What I want to have in my inventory, in the order I want it.

  # Preferences in plain english:
  # - Not starve to death.
  #   - Do not allow the (expected) inventory of fish to drop below zero.
  # - Have at least a stock of 15 fish to protect against future uncertainty.
  #   - Willing to have no leisure days to get this.
  # - Have less than 5% leisure days for 60 days, and then get 20% leisure days.
  #   - Act on this if I predict that I can make it work and I don't already
  #     predict that I'll have leisure on 20% of days.
  #
  # - Leisure
  #   - This one is weird because the desire for it is unlimited so it isn't
  #     an achievable preference.


  # Inventory of 15 fish and 1 day  of leisure
  # Inventory of 15 fish and 0 days of leisure
  # ...
  # Inventory of  1 fish and 0 days of leisure
  # NOTE: leisure can never be more than 1 because it is always consumed as it
  #       is produced.
  def preferences
    [
      {fish: 15, leisure: 1},
      {fish: 15, leisure: 0},
      {fish: 14, leisure: 0},
      {fish: 13, leisure: 0},
      {fish: 12, leisure: 0},
      {fish: 11, leisure: 0},
      {fish: 10, leisure: 0},
      {fish:  9, leisure: 0},
      {fish:  8, leisure: 0},
      {fish:  7, leisure: 0},
      {fish:  6, leisure: 0},
      {fish:  5, leisure: 0},
      {fish:  4, leisure: 0},
      {fish:  3, leisure: 0},
      {fish:  2, leisure: 0},
      {fish:  1, leisure: 0},
      {fish:  0, leisure: 0}
    ]
  end

  def rank_potential_inventory(potential_inventory)
    result = preferences.size
    preferences.detect.with_index do |preference, index|
      if preference.keys.all? { |key| (potential_inventory[key] || 0) >= preference[key] }
        result = index
      end
    end
    result
  end
end
