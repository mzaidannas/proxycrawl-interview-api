class ApplicationController < ActionController::Metal
  FLUSH_EVERY = 100

  include ActionController::Rendering        # enables rendering
  include ActionController::MimeResponds     # enables serving different content types like :xml or :json
  include AbstractController::Callbacks      # callbacks for your authentication logic
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD']

  before_action -> { response.headers['Content-Type'] = 'application/json' }

  private

  # Curl requires the --compressed flag for this response to load correctly.
  def stream_json_array(result)
    # headers['Content-Disposition'] = 'attachment' # Download response to file. It's big.
    headers['Content-Type']        = 'application/json'
    headers['Content-Encoding']    = 'deflate'

    deflate = Zlib::Deflate.new

    buffer = "[\n  "
    i = 0
    result.stream_each do |object|
      buffer << ",\n  " unless i == 0
      buffer << Oj.dump(object, mode: :compat, time_format: :ruby)

      if i % FLUSH_EVERY == 0
        write(deflate, buffer)
        buffer = ''
      end
      i += 1
    end
    buffer << "\n]\n"

    write(deflate, buffer)
    write(deflate, nil) # Flush deflate.
    result.clear
    response.stream.close
  end

  def write(deflate, data)
    deflated = deflate.deflate(data)
    response.stream.write(deflated)
  end
end
