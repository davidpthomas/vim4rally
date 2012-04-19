class ConnectionController < RallyController

  attr_accessor :conn

  def initialize
    super()    # this class bootstraps creation of 'rally' global var
  end

  private

  # Create the connection context to provide access to Rally
  def execute
    @conn = RallyConnection.new
    @conn.connect
  end

end
