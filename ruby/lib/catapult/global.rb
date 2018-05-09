module Catapult
  module Global
    def self.component_address(node_type, index)
      "#{node_type}-#{index}"
    end

    MONGO_HOST = 'db'
    def self.mongo_host
      MONGO_HOST
    end

    module CatapultPort
      PEER_PORT = 7900
      API_PORT  = 7902
      
      # node_type value in set {:peer_node, :api_node}
      def self.peer_port(node_type)
        PEER_PORT 
      end
      
      def self.api_port
        API_PORT 
      end
    end
    
  end
end
