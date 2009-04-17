require File.join(File.dirname(__FILE__), '..', 'spec_helper')

class Airplane
  include AASM
  aasm_initial_state :landed
  aasm_state :taking_off
  aasm_state :landed
  aasm_state :descending
  aasm_state :in_flight
  aasm_state :crashing

  aasm_event :descend do
    transitions :to => :descending, :from => :in_flight
  end

  aasm_event :land do
    transitions :to => :landed, :from => :descending
  end

  aasm_event :take_off do
    transitions :to => :in_flight, :from => :landed
  end
end

class FighterPlane < Airplane
  include AASM

  aasm_state :barrel_rolling
  aasm_state :warp_speed
  aasm_state :in_combat

  aasm_event :attack do
    transitions :to => :in_combat, :from => :in_flight
  end

  aasm_event :warp_speed do
    transitions :to => :warp_speed, :from => :in_flight
  end
end

describe AASM, ' - When inheriting states' do

  it 'should inherit all of the superclass states' do
    [ :taking_off, :landed, :descending, :in_flight, :crashing ].each do |state|
      FighterPlane.aasm_states.should include(state)
    end
  end

  it 'should include its own defined states' do
    [ :barrel_rolling, :warp_speed, :in_combat ].each do |state|
      FighterPlane.aasm_states.should include(state)
    end
  end

end

describe AASM, ' - When inheriting events' do

  before :each do 
    @fighter_plane = FighterPlane.new
  end

  it 'should include all of the superclass events' do
    [ :descend!, :land!, :take_off! ].each do |event|
      @fighter_plane.should respond_to(event)
    end
  end

  it 'should include all of its own defined events' do
    [ :attack!, :warp_speed! ].each do |event|
      @fighter_plane.should respond_to(event)
    end
  end

end

describe AASM, ' - superclass behavior with regard to subclass states' do

  it 'should not include its subclass states' do
    [ :barrel_rolling, :warp_speed, :in_combat ].each do |state|
      Airplane.aasm_states.should_not include(state)
    end
  end

end

