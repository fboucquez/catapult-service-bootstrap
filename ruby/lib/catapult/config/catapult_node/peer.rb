module Catapult
  class Config::CatapultNode
    class Peer
      def initialize(type, index)
        @type         = type
        @index        = index
        @host_address = Global.component_address(type, index)
        @host         = self.class.host(type, index)
        @port         = self.class.port(type)
        @name         = self.class.name(type, index)
      end
      private :initialize
      
      attr_reader :type, :index, :host, :host_address, :port, :name
      
      TYPES = [:api_node, :peer_node]
      def self.all_peers(dtk_all_attributes)
        peers = []
        TYPES.each do |type|
          (0..Config.cardinality(type)).to_a.each do |index|
            peers << Peer.new(type, index)
          end
        end
        peers
      end
      
      def self.host(type, index)
        Global.component_address(type, index)
      end
      
      def self.name(type, index)
        host(type, index)
      end
      
      def self.port(type)
        Global::CatapultPort.peer_port(type)
      end
        
    end
  end
end
