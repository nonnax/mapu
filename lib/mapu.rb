#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2022-04-04 18:16:46 +0800
require 'tilt'

module Mapu
  D, routes = Object.method(:define_method), Hash.new { |h, k| h[k] = [] }
  D[:map] { routes }
  D[:res] { @res }
  D[:req] { @req }

  %w[GET POST PUT DELETE].map do |m|
    D[m.downcase] do |u, **opts, &block|
      r = { u:, opts:, block: }
      routes[m] << r
    end
  end

  def self.call(env)
    @req, @res = Rack::Request.new(env), Rack::Response.new
    res.headers['Content-type'] = 'text/html; charset=utf-8'
    m, pi = env.values_at('REQUEST_METHOD', 'PATH_INFO')
    if x = map[m].detect { |r| r[:u] == pi }
      res.headers.merge!(x[:opts].transform_keys(&:to_s))
      res.write instance_exec(req.params, x[:opts], &x[:block])
      return res.finish
    end
    [404, {}, ['Oops!']]
  end

  Tilt.default_mapping.lazy_map.each do |ext, eng|
    define_method(ext) do |arg, *args|
      opts = args.grep(Hash).pop[:locals] rescue {}
      engine = Kernel.const_get(eng.last.first)

      arg = File.read(File.expand_path("../views/#{arg}.erb", __dir__)) if arg.is_a?(Symbol)      
      layout = File.read(File.expand_path("../views/layout.erb", __dir__)).then{|l| engine.new(*args){l} } 
            
      engine.new(*args){ arg }
      .then{|t| t.render(self, opts) }
      .then{|doc| layout.render(self, opts){ doc } }
    end
  end
  self
end.tap{|x| include x}
