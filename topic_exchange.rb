require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel

exchange = channel.topic("news", :auto_delete => true)

channel.queue("", :exclusive => true).bind(exchange, :routing_key => "world.politics.#").subscribe do |info, metadata, payload|
  puts "on the topic of politics, #{payload}, routing key => #{info.routing_key}"
end

channel.queue("", :exclusive => true).bind(exchange, :routing_key => "#.internetgovernance.cybercrime").subscribe do |info, metadata, payload|
  puts "on the topic of internet governance, #{payload}, routing key => #{info.routing_key}"
end

channel.queue("", :exclusive => true).bind(exchange, :routing_key => "world.politics.internetgovernance.*").subscribe do |info, metadata, payload|
  puts "on the topics of the world, politics, and internet governance #{payload}, routing key => #{info.routing_key}"
end

# we would expect to see this message thrice
exchange.publish("Havoc ensues", :routing_key => "world.politics.internetgovernance.cybercrime")

# we would expect to see this one times
exchange.publish("People come together", :routing_key => "world.politics.someother.nonrelatedtopic")

# we would expect to see this one times
exchange.publish("People ponder the relevance of copyright", :routing_key => "global.ambassadorship.internetgovernance.cybercrime")

# we would expect to see this twice
exchange.publish("Confusion is lifted", :routing_key => "world.politics.internetgovernance.netneutrality")

sleep 1.0

connection.close