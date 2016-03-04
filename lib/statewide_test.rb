require 'pry'


class StatewideTest

  attr_accessor :name, :class_data

  def initialize(args)
    @name = args[:name].upcase
    @class_data = {}
    organize_data(args)
  end

  def truncate_percentages(hash)
    hash.map do |year,value|
      [year.to_i, truncate(value.to_f)]
    end.to_h
  end

  def truncate(value)
    ((value * 1000).floor / 1000.0)
  end 

  def organize_data(args)
    args.each_pair do |source, subject_hash|
      next if source == :name
      subject_hash.each do |subject, data|
        @class_data[source][subject] = truncate_percentages(args[subject])
      end
    end
  end
end



# location
# race ethnicity / score
# timeframe
# dataformat
# data
