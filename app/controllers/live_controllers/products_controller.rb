class LiveControllers::ProductsController < ApplicationController
  include ActionController::Live

  def index
    connection = ActiveRecord::Base.connection.raw_connection
    # Feeds the DB with the query it will run
    # But it does NOT execute it yet!
    query = Product.all.to_sql
    connection.send_query(query)
    # This line  sets DB’s mode
    # as single line, which instead of sending the results all at once,
    # it sends them line by line, as requested by the application.
    connection.set_single_row_mode
    # This will return the next result from DB, and if you use stream_each
    # right after it, it will stream the results one by one until there
    # are no more results to fetch.
    stream_json_array(connection.get_result)
  end
end
