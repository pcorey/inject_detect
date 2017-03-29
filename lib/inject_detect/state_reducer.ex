defprotocol InjectDetect.State.Reducer do

  def apply(event, data)

end
