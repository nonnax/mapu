#!/usr/bin/env ruby
# Id$ nonnax 2022-04-04 18:34:08 +0800
require_relative 'lib/mapu'
# require 'mapu'

get '/' do |param|
  erb :template, locals: param
end

get '/hi' do |param|
  erb "hey #{param}"
end

get '/mark' do |param|
  md "# hey #{param}"
end

post '/', 'Content-type': 'application/json' do |params, data|
  erb ['params: '+params.inspect,   'data: '+data.inspect].join(","), locals: {partial: true}
end

get '/r' do |params, data|
  res.redirect '/'
end

run Mapu
