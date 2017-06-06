defprotocol InjectDetect.Event do

  @fallback_to_any true

  def convert_from(event, version)

end

defimpl InjectDetect.Event, for: Any do

  def convert_from(event, _version), do: event

end
