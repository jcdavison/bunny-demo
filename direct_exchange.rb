require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel

queue1 = channel.queue("postoffice.mick", :auto_delete => true)
queue2 = channel.queue("postoffice.roni", :auto_delete => true)
queue3 = channel.queue("postoffice.ian", :auto_delete => true)

exchange = channel.default_exchange

queue1.subscribe do | info, metatdata, payload |
  puts "mick's box received, #{payload}"
end

queue2.subscribe do | info, metatdata, payload |
  puts "roni's box received, #{payload}"
end

queue3.subscribe do | info, metatdata, payload |
  puts "ian's box received, #{payload}"
end

exchange.publish("i like big waves", :routing_key => "postoffice.ian")
  .publish("i like making apps", :routing_key => "postoffice.roni")
  .publish("i like winning big titles", :routing_key => "postoffice.mick")

sleep 1.0

connection.close
