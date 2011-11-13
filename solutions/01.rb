class Array
  def to_hash()
    result = {}
    each do |sublist| 
      result[sublist[0]] = sublist[1] if sublist.length > 0 
    end
    result
  end
  
  def index_by()
    map {|value| [yield(value), value]}.to_hash
  end
  
  def subarray_count(subarray)
    each_cons(subarray.length).count(subarray)
  end
  
  def occurences_count()
    result = Hash.new 0
    each do |value| 
      result[value] += 1
    end
    result
  end
end
