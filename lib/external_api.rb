require 'json'

class ExternalApi
  PAGE_SIZE = 10
  def initialize(db_file)
    @db = JSON.parse(File.read(db_file)).group_by{|record| record["evaluado_id"].to_i}
  end

  def fetch_results(employee_id, page = 1)
    # Return the next page of results.  If page == 0, starts from the
    # beginning.  Otherwise, fetches the next 10 records after the last page.
    # returns:
    #     {
    #         "results": [{evaluado: text, id: integer, result: integer}, {evaluado: text, id: integer, result: integer}, ...],
    #         "page": 1
    #     }
    return {'page': page, 'results': nil}.to_json if page.negative? || page.zero? || !db.key?(employee_id)
    return {
      'page': page,
      'results': db.fetch(employee_id, nil)&.slice(PAGE_SIZE * (page - 1), PAGE_SIZE),
    }.to_json
  end

  private
    attr_reader :db
end

