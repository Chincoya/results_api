# [{id: <id>, evaluado: <id_evaluado>, result: <result>, kind: <kind>}, {id: <id>, evaluado: <id_evaluado>, result: <result>, kind: <kind>}]
require 'json'


module Generator
  EXAMPLE_FILE_NAME = "example.json"
  PARTICIPANTS = 20
  COIN_OPTIONS = [true, false].freeze
  RESULTS = [1, 2, 3, 4, 5].freeze
  EXAMPLE_WEIGHTS = {
    ascending: 20,
    descending: 50,
    autoevaluation: 10,
    parallel: 20,
  }.freeze
  EXAMPLE_MAX_EVALUATORS = {
    ascending: 2,
    descending: 5,
    parallel: 8,
    autoevaluation: 1,
  }.freeze

  def flip_coin
    COIN_OPTIONS.sample
  end
  module_function :flip_coin

  def sample_result
    RESULTS.sample
  end
  module_function :sample_result

  def generate(file_name, participants, weights, evaluators)
    data = []
    id = 0
    participants.times do |i|
      evaluado_id = i + 1
      evaluators.each do |kind, cantidad_maxima_evaluadores|
        cantidad_maxima_evaluadores.times do |j|
          if flip_coin
            id += 1
            data << { id: id, evaluado_id: evaluado_id, result: sample_result, kind: kind }
          end
        end
      end
    end
    File.write(file_name, JSON.dump(data))
  end
  module_function :generate

  def generate_example
    generate(EXAMPLE_FILE_NAME, PARTICIPANTS, EXAMPLE_WEIGHTS, EXAMPLE_MAX_EVALUATORS)
  end
  module_function :generate_example


  # pesos_evaluacion_dos = { descending: 50, autoevaluation: 30, parallel: 20 }
  # cantidad_maxima_evaluadores_evaluacion_dos = { descending: 35, parallel: 20, autoevaluation: 1 }
  # data_evaluacion_dos = []
  # id = 0
  # CANTIDAD_EVALUADOS.times do |i|
  #   evaluado_id = i + 1
  #   cantidad_maxima_evaluadores_evaluacion_uno.each do |kind, cantidad_maxima_evaluadores|
  #     cantidad_maxima_evaluadores.times do |j|
  #       if flip_coin
  #         data = {}
  #         id += 1
  #         data_evaluacion_dos << { id: id, evaluado_id: evaluado_id, result: result, kind: kind }
  #       end
  #     end
  #   end
  # end

  # File.write('./sample_2.json', JSON.dump(data_evaluacion_dos))
end
