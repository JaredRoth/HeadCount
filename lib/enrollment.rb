require_relative 'module_helper'

class Enrollment
  include Helper

  attr_accessor :name, :grade_data

  def initialize(args)
    @name = args[:name].upcase
    @grade_data = {}
    organize_data(args)
  end

  def organize_data(args)
    args.each_pair do |source, grouped_data|
      next if source == :name
      if source == :kindergarten_participation
        @grade_data[:kindergarten] = truncate_percentages(args[source])
      else
        @grade_data[source] = truncate_percentages(args[source])
      end
    end
  end

  def kindergarten_participation_by_year
    @grade_data[:kindergarten]
  end

  def kindergarten_participation_in_year(year)
    @grade_data[:kindergarten].fetch(year, nil)
  end

  def graduation_rate_by_year
    @grade_data[:high_school_graduation]
  end

  def graduation_rate_in_year(year)
    @grade_data[:high_school_graduation].fetch(year, nil)
  end
end
