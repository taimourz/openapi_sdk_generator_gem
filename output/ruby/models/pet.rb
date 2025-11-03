# Pet
class Pet
  attr_accessor :id
  attr_accessor :name
  attr_accessor :tag
  attr_accessor :status
  
  def initialize(attributes = {})
    @id = attributes['id'] || attributes[:id]
    @name = attributes['name'] || attributes[:name]
    @tag = attributes['tag'] || attributes[:tag]
    @status = attributes['status'] || attributes[:status]
  end
  
  def to_h
    {
      'id' => @id,
      'name' => @name,
      'tag' => @tag,
      'status' => @status
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