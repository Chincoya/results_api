require_relative "./lib/external_api"
client = ExternalApi.new("./data/example.json")
puts client.fetch_participants
puts client.fetch_results(2)

