require 'csv'
class Repository


  def load_data(params=nil)
    params ||= {
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"
    }
  }
    data = {}
    params.each{|type,hash|
      hash.each{|source,filename|
        data = CSV.readlines(filename, headers: true, header_converters: :symbol).flat_map{ |row|
          row.to_h.merge(source: source)
        }
      }
    }
    #binding.pry
    data
  end

end
