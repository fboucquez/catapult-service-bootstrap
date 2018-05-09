module Catapult
  class Config
    require_relative('config/template_attributes')
    # simple and template_attributes must go first
    require_relative('config/keys')
    require_relative('config/paths')
    require_relative('config/source_target_pair')
    
    # child classes
    require_relative('config/catapult_node')
    
    include Paths::Mixin
    extend Paths::ClassMixin
    
    def initialize(type, dtk_all_attributes, template_attributes)
      @type                  = type
      @config_info_dir       = self.class.config_info_dir
      @template_attributes   = template_attributes
      # gets dynamically updated
      @ndx_config_files = {} #@ndx_config_files is indexed by TYPE-INDEX
    end
    
    private :initialize
    
    # Returns array that has same size as cardinality
    def configure
      add_static_config_files
      add_instantiate_config_templates
      write_out_config_files
    end

    CARDINALITY = {
      api_node: 1,
      peer_node: 2
    }
    def self.cardinality(type)
      CARDINALITY[type] || fail("Unexpected type '#{type}'")
    end
    
    def self.type
      self::TYPE
    end

    def self.component_indexes(cardinality)
      (0..cardinality-1).to_a
    end
        
    protected
    
    attr_reader :type, :dtk_all_attributes, :config_info_dir, :template_attributes, :ndx_config_files
    
    def cardinality
      @cardinality ||= self.class.cardinality(self.type)
    end

    def component_indexes
      @component_indexes ||= self.class.component_indexes(self.cardinality)
    end
    
    private
    
    def add_static_config_files
      add_static_files(:config_file, self.all_files_in_config_info_dir)
    end

    # type can be :script, :config_file
    def add_static_files(file_type, static_files)
      SourceTargetPair.config_files(static_files).each do |pair|
        path    = relative_path(file_type, pair.filename)
        content = File.open(pair.source_path).read
        self.component_indexes.each { |index| add_config_file!(index, path, content) }
      end
    end
    
    # Can be overwritten
    def add_instantiate_config_templates
      SourceTargetPair.config_templates(self.all_files_in_config_info_dir).each do |pair|
        template_path = pair.source_path
        template      = File.open(template_path).read
        self.component_indexes.each do |index| 
          instantiated_template = Catapult.bind_mustache_variables(template, self.template_attributes.hash(index))
          path = relative_path(:config_file, pair.filename)
          add_config_file!(index, path, instantiated_template)
        end 
      end
    end
    
    def add_config_file!(component_index, path, content)
      ndx = "#{self.type}#{component_index}"
      (self.ndx_config_files[ndx] ||= {}).merge!(path => content)
    end

    # TODO: stub for test
    BASE_DIR = '/tmp/community'
    def write_out_config_files
      self.ndx_config_files.each_pair do |component_ref, info|
        component_dir = "#{BASE_DIR}/#{component_ref}"
        info.each_pair do |path, content|
          full_path = "#{component_dir}/#{path}"
          FileUtils.mkdir_p(directory_part(full_path))
          File.open(full_path, 'w') { |f| f << content }
        end
      end
    end

    def directory_part(full_path)
      split = full_path.split('/')
      split.pop
      split.join('/')
    end

  end
end
