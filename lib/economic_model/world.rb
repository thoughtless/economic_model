require_relative "../economic_model"
require_relative "person"

class EconomicModel::World
  def initialize
    @day = 0
    @crusoe = EconomicModel::Person.new "Robinson Crusoe"
    @people = [@crusoe]
  end

  # Returns a string description of the world
  def status
    result = []
    result << "-"*50

    result << "Day: #{@day}"

    result << "People:"
    @people.each do |person|
      result << "  * #{person.status(4)}"
    end

    result << "-"*50
    result.join("\n")
  end

  # Make a day pass
  def continue
    @day += 1
    @people.each do |person|
      person.continue
    end
  end
end
