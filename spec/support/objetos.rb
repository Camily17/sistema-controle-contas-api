module Objetos
  def self.converter_hash_simbolizado(objeto)
    objeto.as_json.compact.symbolize_keys
  end
end