require_relative 'module_helper'

class StatewideTest
  include Helper

  attr_accessor :name, :class_data

  def initialize(args)
    @name = args[:name].upcase
    @class_data = {}
    organize_data(args)
  end

  def organize_data(args)
    args.each_pair do |source, subject_hash|
      next if source == :name
      @class_data[source] = {}
      subject_hash.each do |subject, data|
        @class_data[source][subject] = data
      end
    end
  end

  def check_grade(grade)
    grades = {3 => :third_grade, 8 => :eighth_grade}
    error?(grades.has_key?(grade))
    grades[grade]
  end

  def proficient_by_grade(grade)
    grade = check_grade(grade)

    @class_data[grade][:math].map do |year, data|
      [year, Hash[:math, data,
               :reading, class_data[grade][:reading][year],
               :writing, class_data[grade][:writing][year]]]
    end.to_h
  end

  def proficient_by_race_or_ethnicity(race)
    races = [:asian,
             :black,
             :pacific_islander,
             :hispanic,
             :native_american,
             :two_or_more,
             :white]
    error?(races.include?(race))

    @class_data[:math][race].map do |year, data|
      [year, Hash[:math, data,
               :reading, class_data[:reading][race][year],
               :writing, class_data[:writing][race][year]]]
    end.to_h
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    subjects = [:math, :reading, :writing]
    error?(subjects.include?(subject))
    grade = check_grade(grade)
    error?(@class_data[grade][subject].key?(year))

    @class_data[grade][subject][year]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    subjects = [:math, :reading, :writing]
    races    = [:asian,
                :black,
                :pacific_islander,
                :hispanic,
                :native_american,
                :two_or_more,
                :white]
    error?(subjects.include?(subject))
    error?(races.include?(race))
    error?(@class_data[subject][race].key?(year))

    @class_data[subject][race][year]
  end
end
