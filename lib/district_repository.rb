require_relative 'district'
require_relative 'enrollment_repository'
require 'csv'

class DistrictRepository

  attr_reader :districts, :enrollment_repo

  def initialize
    @districts = []
    @enrollment_repo = EnrollmentRepository.new
  end


  def load_data(file)

    filename = file[:enrollment][:kindergarten]

    data = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
    build_all_repos(data)
  end

  def build_all_repos(data)
    create_district_repo(data)
    # @enrollment_repo.build_repo(data)
    insert_enrollment_info_into_districts
  end

  def insert_enrollment_info_into_districts
    districts.each do |district|
      district.enrollment = @enrollment_repo.find_by_name(district.name)
    end
  end

  def create_district_repo(data)
    data.each do |row|
      next if find_by_name(row[:location].upcase)
      districts << District.new(name: row[:location])
    end
  end

  def find_by_name(location)
    districts.find { |district| district.name == location.upcase }
  end

  def find_all_matching(location)
    districts.find_all { |district| district.name.include?(location.upcase)}
  end
end
