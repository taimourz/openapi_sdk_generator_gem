# Error
class Error
  attr_accessor :code
  attr_accessor :message
  
  def initialize(attributes = {})
    @code = attributes['code'] || attributes[:code]
    @message = attributes['message'] || attributes[:message]
  end
  
  def to_h
    {
      'code' => @code,
      'message' => @message
    }
  end
  
  def to_json(*args)
    to_h.to_json(*args)
  end
  
  def self.from_json(json)
    data = JSON.parse(json)
    new(data)
  end
end