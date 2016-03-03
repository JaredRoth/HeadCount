require_relative 'district'
require_relative 'enrollment_repository'
require 'csv'

class DistrictRepository

  attr_reader :districts, :enrollment_repo

  def initialize
    @districts = []
    @enrollment_repo = EnrollmentRepository.new
    # @statewide_repo  = StatewideRepository.new
    # @economic_repo   = EconomicRepository.new
  end

  def load_data(files)
    create_district_repo(files)

    files.each do |repo_type, sources|
      build_correct_repo(repo_type, sources)
    end
  end

  def build_correct_repo(key, sources)
    repos = {enrollment: build_enrollment_repo(sources),
    # statewide_testing:   build_statewide_repo(sources),
    # economic_profile:    build_economic_repo(sources)
  }
    repos[key]
  end

  def build_enrollment_repo(sources)
    @enrollment_repo.load_data(sources)
    insert_info_into_districts(@enrollment_repo)
  end

  def build_statewide_repo(sources)
    @statewide_repo.load_data(sources)
    insert_info_into_districts(@statewide_repo)
  end

  def build_economic_repo(sources)
    @economic_repo.load_data(sources)
    insert_info_into_districts(@economic_repo)
  end

  def insert_info_into_districts(repo)
    districts.each do |district|
      district.enrollment = repo.find_by_name(district.name)
    end
  end

  def create_district_repo(files)
    filename = files[:enrollment][:kindergarten]
    data = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
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
