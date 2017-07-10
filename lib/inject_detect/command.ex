defprotocol InjectDetect.Command do
  def handle(command, context, state)
end

