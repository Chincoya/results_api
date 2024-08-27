require_relative "./external_api"



MAX_SCORE = 5
{
  descending: 50,
  asc: 25,
  paral: 20,
  auto: 5,
}
#max evaluadores
{
  desc: 5,
  asc: 10,
  paral: 10,
}

client = ExternalApi.new

puts client.fetch_results(2)
puts client.fetch_results(4)
puts client.fetch_results(3)
puts client.fetch_results(5)
