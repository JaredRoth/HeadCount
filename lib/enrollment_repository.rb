require_relative 'repository'
require_relative 'enrollment'
require_relative 'module_helper'
require 'csv'
require 'pry'


class EnrollmentRepository < Repository
  include Helper

  attr_reader :enrollments

  def initialize
    #Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})

    @data = load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    @enrollments = group_data.keys.map do |location|
      Enrollment.new(name: location,participation:get_participation_hash(location))
    end

  end

  def get_participation_hash(location)
    group_data.fetch(location,nil).map{|hash| [hash[:timeframe],truncate(hash[:data].to_f)] }.to_h
  end

  def find_by_name(location)
    enrollments.find { |enrollment| enrollment.name.upcase == location.upcase}
  end
end

=begin
er = EnrollmentRepository.new
er.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv"
  }
})
binding.pry
enrollment = er.find_by_name("ACADEMY 20")
=end
