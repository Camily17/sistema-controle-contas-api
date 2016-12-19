module Requests
  module JsonHelpers
    def symbolizar_json(body)
      JSON.parse(body, symbolize_names: true)
    end
  end
end
