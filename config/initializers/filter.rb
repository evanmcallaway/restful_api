class Filter < Hash
  
  # returns the value of the key as if it were a method
  def method_missing(method_name, *arguments, &block)
    self[method_name]
  end
  
  # returns a json that can be passed as ajax to the correct actions
  def to_json
    Hash[self.map { |key, value| ["filter[#{key}]", value] }].to_json
  end
  
  # takes in the same arguments as Hash, but symbolizes keys after instantiation
  def self.[](*arguments)
    super
    super.symbolize_keys!
  end
  
end