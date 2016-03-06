require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'
require 'csv'

class DistrictRepository

  attr_reader :districts, :enrollment_repo, :statewide_repo

  def initialize
    @districts = []
    @enrollment_repo = EnrollmentRepository.new
    @statewide_repo  = StatewideTestRepository.new
    @economic_repo   = EconomicProfileRepository.new
  end

  def load_data(repo_types)
    create_district_repo(repo_types)

    repo_types.each do |repo_type, files|
      build_correct_repo(repo_type, files)
    end
  end

  def build_correct_repo(repo_type, files)
    reposotpries = {enrollment: @enrollment_repo,
             statewide_testing: @statewide_repo,
              economic_profile: @economic_repo}

    instances    = {enrollment: district.enrollment,
             statewide_testing: district.statewide_test,
              economic_profile: district.economic_profile}

    repo = repositories[repo_type]
    instance = instances[repo_type]

    repo.load_data({repo_type => files})
    insert_info_into_districts(repo, instance)
  end

  def insert_info_into_districts(repo, instance)
    districts.each do |district|
      instance = repo.find_by_name(district.name)
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
