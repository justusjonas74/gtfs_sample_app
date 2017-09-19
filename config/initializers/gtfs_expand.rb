GTFS::Source::ENTITIES.each do |entity|
  entity.class_eval do
    def to_hash
      hash = {}
      self.class == GTFS::Agency ? prefix = self.class.to_s.delete("GTFS::").downcase + "_" : prefix = ""
      instance_variables.each {|var| hash[prefix + var.to_s.delete("@")] = instance_variable_get(var) }
      hash
    end
  end
end

[GTFS::Calendar, GTFS::CalendarDate, GTFS::Trip].each do |entity|
  entity.class_eval do
    alias_method :calendar_id, :service_id
  end
end


# TEST 
module GTFS
  module Model
    def self.included(base)
      base.extend ClassMethods

      base.class_variable_set('@@prefix', '')
      base.class_variable_set('@@optional_attrs', [])
      base.class_variable_set('@@required_attrs', [])

      def valid?
        !self.class.required_attrs.any?{|f| self.send(f.to_sym).nil?}
      end

      def initialize(attrs)
        attrs.each do |key, val|
          instance_variable_set("@#{key}", val)
        end
      end
    end

    module ClassMethods

      #####################################
      # Getters for class variables
      #####################################

      def prefix
        self.class_variable_get('@@prefix')
      end

      def optional_attrs
        self.class_variable_get('@@optional_attrs')
      end

      def required_attrs
        self.class_variable_get('@@required_attrs')
      end

      def attrs
      required_attrs + optional_attrs
      end

      #####################################
      # Helper methods for setting up class variables
      #####################################

      def has_required_attrs(*attrs)
        self.class_variable_set('@@required_attrs', attrs)
      end

      def has_optional_attrs(*attrs)
        self.class_variable_set('@@optional_attrs', attrs)
      end

      def column_prefix(prefix)
        self.class_variable_set('@@prefix', prefix)
      end

      def required_file(required)
        self.define_singleton_method(:required_file?) {required}
      end

      def collection_name(collection_name)
        self.define_singleton_method(:name) {collection_name}

        self.define_singleton_method(:singular_name) {
          self.to_s.split('::').last.
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").downcase
        }
      end

      def uses_filename(filename)
        self.define_singleton_method(:filename) {filename}
      end

      def each(filename)
        headers = nil
        CSV.foreach(filename, :headers => true) do |row|
          headers ||= unprefixed_headers(row.headers)
          yield parse_model(headers, row.fields)
        end
      end

      def unprefixed_headers(headers)
        headers.map{|h| h.gsub(/^#{prefix}/, '')}
      end

      def parse_model(headers, fields, options={})
        self.new(Hash[headers.zip(fields)])
      end

      def parse_models(data, options={})
        return [] if data.nil? || data.empty?

        models = []
        headers = nil
        CSV.parse(data, :headers => true) do |row|
          headers ||= unprefixed_headers(row.headers)
          model = parse_model(headers, row.fields)
          models << model if options[:strict] == false || model.valid?
        end
        models
      end
    end
  end
end

# TEST 


# def import_gtfs_source(source, model, hash, link = {})
#   i = 0
#   arr = []
#   c = "each_#{model}"
#   if source.respond_to?(c)
#     source.send(c) do |se|
#         m = model.to_s.classify.constantize.new do |me|
#           hash.each do |key,val|
#             if val.nil?; me.public_send(key.to_s + "=", se.public_send(key)) else me.public_send(key.to_s + "=", se.public_send(val)) end
#           end
#         end
#         if !link.empty?
#           link.each do |key,val|
#             ret = se.public_send(val)
#             unless ret == nil || ret ==""
#               searchblock = "#{key.to_s.chomp("_id").classify.constantize.connection.quote_column_name(val)} = ?"
#               id = key.to_s.chomp("_id").classify.constantize.where( searchblock , ret).take.id
#               m.public_send(key.to_s + "=", id)
#             end
#           end
#         end
#         arr << m
#       i +=1
#       print "Import #{model.to_s.humanize} item no. #{i} \r"
#       $stdout.flush
#     end
#   end
#   puts "#{i} items from #{model.to_s}.txt added to memory."
#   model.to_s.classify.constantize.import arr, :batch_size => 10_000
#   puts "#{i} items from #{model.to_s}.txt added to Database."
# end

def import_gtfs_source(source, model, hash, link = {})
  i = 0
  c = "each_#{model}"
  if source.respond_to?(c)
    columns = hash.keys + link.keys 
    values = []
    source.send(c) do |se|
      entry = []
      hash.each do |key,val|
        if val.nil?; entry << se.public_send(key) else entry << se.public_send(val) end
      end
      if !link.empty?
        link.each do |key,val|
          ret = se.public_send(val)
          unless ret == nil || ret ==""
            searchblock = "#{key.to_s.chomp("_id").classify.constantize.connection.quote_column_name(val)} = ?"
            entry << key.to_s.chomp("_id").classify.constantize.where( searchblock , ret).take.id
          else
            entry << nil
          end
        end
      end
      values << entry
      i +=1
      print "Import #{model.to_s.humanize} item no. #{i} \r"
      $stdout.flush
    end
  end
  puts "#{i} items from #{model.to_s}.txt added to memory."
  #model.to_s.classify.constantize.import columns, values, :validate => false, :batch_size => 10_000
  model.to_s.classify.constantize.import columns, values, :validate => false 
  puts "#{i} items from #{model.to_s}.txt added to Database."
end

 #   i = 0
    #   stop_times = []
    #   source.each_stop_time do |st|
    #     stop_times << StopTime.create(st.to_hash)
    #     i +=1
    #     print "Import Stop Time Number #{i} \r"
    #     $stdout.flush
    #   end
    #   puts "#{i} items from stop_times.txt added to memory."
    #   StopTime.import stop_times
    #   puts "#{i} items from stop_times.txt added to Database."
    #   stop_times = nil
