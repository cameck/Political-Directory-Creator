require_relative "person"

class Politician < Person
  attr_accessor :party

  def initialize(name, party)
    super(name)
    @party = party
  end
end
