require_relative 'client'
require_relative 'logger'
require_relative 'message_builder'
require_relative 'utility'


class LinkStateManager

	INFINITY = 'Infinity'
	@@link_state_table = {}

	def self.broadcast_link_state
		#---------------------------------------------------
        # read costs file
        #---------------------------------------------------
        cost_map, ip_map = Utility.read_link_costs($__weight_file)

        neighbors_cost_map = cost_map[$__node_name]
        neighbors_ip_map = ip_map[$__node_name]
        #---------------------------------------------------
        # check link-state and construct link-state message
        #---------------------------------------------------
        link_state_message = {}
        neighbors_cost_map.each do |neighbor, cost|
          ip = neighbors_ip_map[neighbor]
          port = $__node_ports[neighbor]
          hello_msg = MessageBuilder.create_hello_message($__node_name)
          begin
            Client.send(hello_msg, ip, port)
            link_state_message[neighbor] = cost
          rescue Exception => e
            Logger.error("#{e} #{name}")
            link_state_message[neighbor] = INFINITY
          end
        end

        #---------------------------------------------------
        # send packet to alive neighbors
        #---------------------------------------------------
        flood_msg = MessageBuilder.create_flood_message($__node_name, link_state_message)
        link_state_message.each do |neighbor, cost|
          ip, _ = neighbors[neighbor]
          port = $__node_ports[neighbor]
          # puts "flodd: #{flood_msg}, name: #{name}, ip: #{ip}, port: #{port}"
          # Client.send(flood_msg, ip, port)
        end
	end


	@@parsed_flood_mgs = Queue.new
	def self.handle_flooding
		loop {
			parsed_flood_msg = @@parsed_flood_mgs.pop	# block waiting for flood message
			# puts "new msg: #{parsed_flood_msg}"
			sender = parsed_flood_msg['HEADER']['SENDER']
			sequence = parsed_flood_msg['HEADER']['SEQUENCE']
			puts "#{sender}, #{sequence}"



		}
	end

	def self.enqueue(parsed_flood_msg)
		@@parsed_flood_mgs << parsed_flood_msg
	end
end