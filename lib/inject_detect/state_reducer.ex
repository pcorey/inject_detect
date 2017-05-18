defprotocol InjectDetect.State.Reducer do

  def apply(event, data)

end

defimpl InjectDetect.State.Reducer, for: Any do

  def apply(event, state), do: state

end
