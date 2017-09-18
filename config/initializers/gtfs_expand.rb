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


def import_gtfs_source(source, model, hash, link = {})
  i = 0
  arr = []
  c = "each_#{model}"
  if source.respond_to?(c)
    source.send(c) do |se|
        m = model.to_s.classify.constantize.new do |me|
          hash.each do |key,val|
            if val.nil?; me.public_send(key.to_s + "=", se.public_send(key)) else me.public_send(key.to_s + "=", se.public_send(val)) end
          end
        end
        if !link.empty?
          link.each do |key,val|
            ret = se.public_send(val)
            unless ret == nil || ret ==""
              searchblock = "#{key.to_s.chomp("_id").classify.constantize.connection.quote_column_name(val)} = ?"
              id = key.to_s.chomp("_id").classify.constantize.where( searchblock , ret).take.id
              m.public_send(key.to_s + "=", id)
            end
          end
        end
        arr << m
      i +=1
      print "Import #{model.to_s.humanize} item no. #{i} \r"
      $stdout.flush
    end
  end
  puts "#{i} items from #{model.to_s}.txt added to memory."
  model.to_s.classify.constantize.import arr, :batch_size => 10_000
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
