# Pet
class Pet
  attr_accessor :name
  attr_accessor :tag
  attr_accessor :id
  
  def initialize(attributes = {})
    @name = attributes['name'] || attributes[:name]
    @tag = attributes['tag'] || attributes[:tag]
    @id = attributes['id'] || attributes[:id]
  end
  
  def to_h
    {
      'name' => @name,
      'tag' => @tag,
      'id' => @id
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