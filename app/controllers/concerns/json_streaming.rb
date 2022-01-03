module JsonStreaming
  extend ActiveSupport::Concern

  FLUSH_EVERY = 100

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
