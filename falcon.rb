#!/usr/bin/env -S falcon host
# frozen_string_literal: true

load :rack

hostname = File.basename(__dir__)
port = ENV['PORT'] || 3000
workers = ENV['WEB_CONCURRENCY']&.to_i || 2

rack hostname do
  append preload 'config/preload.rb'

  cache true
  verbose false
  count workers

  scheme 'https'
  endpoint Async::HTTP::Endpoint.parse("http://0.0.0.0:#{port}").with(protocol: Async::HTTP::Protocol::HTTP2)
end
