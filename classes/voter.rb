require_relative "person"

class Voter < Person
  attr_accessor :politics

  def initialize(name, politics)
    super(name)
    @politics = politics
  end
end
