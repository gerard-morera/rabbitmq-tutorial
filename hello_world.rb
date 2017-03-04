require "rubygems"
require "bunny"

STDOUT.sync = true

conn = Bunny.new
conn.start

#AMQP 0.9.1 is a multi-channeled protocol that uses channels to multiplex a TCP connection.
ch = conn.create_channel

#declares a queue on the channel that we have just opened
q  = ch.queue("bunny.examples.hello_world", :auto_delete => true)

#instantiates an exchange. Exchanges receive messages that are sent by producers. Exchanges route 
#messages to queues according to rules called bindings. In this particular example, there are no 
#explicitly defined bindings. The exchange that we use is known as the default exchange and 
#it has implied bindings to all queues
x  = ch.default_exchange

#Bunny::Queue#subscribe takes a block that will be called every time a message arrives
q.subscribe do |delivery_info, metadata, payload|
  puts "Received #{payload}"
end


#Routing key is one of the message properties. The default exchange will route the message to a 
#queue that has the same name as the message's routing key.
x.publish("Hello!", :routing_key => q.name)

sleep 1.0
conn.close