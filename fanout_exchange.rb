require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.fanout("surf.swells")

channel.queue("ian", :auto_delete => true).bind(exchange).subscribe do |info, metadata, payload |
  p "#{payload}  => ian"
end

channel.queue("roni", :auto_delete => true).bind(exchange).subscribe do |info, metadata, payload |
  p "#{payload} => roni"
end

channel.queue("mick", :auto_delete => true).bind(exchange).subscribe do |info, metadata, payload |
  p "#{payload} => mick"
end

exchange.publish("lower trestles, perfect head high")
  .publish("ocean beach, double overheads")

sleep 1.0

connection.close