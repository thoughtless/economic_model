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
    top_preference = preferences.detect do |preference|
      # Find the first thing that I don't have all I want of it.
      # I'm going to try to get more of that thing.
      expected_inventory[preference.keys.first] < preference.values.first
    end

    if top_preference
      work(@last_activity = top_preference.keys.first)
    else
      @last_activity = :leisure
    end

    eat
  end

  private

  def inventory
    @inventory
  end

  # Inventory expected at the end of the day.
  def expected_inventory
    inventory = @inventory.dup
    # TODO Dry this up with `Person#eat`
    inventory[:fish] -= @daily_appetite = 10
    inventory
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
  # - Have at least a stock of 25 fish
  # - Leisure
  def preferences
    [
      {fish: 25}
    ]
  end
end
