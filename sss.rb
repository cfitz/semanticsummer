#! /usr/bin/env ruby


# To start the application, use either rackup or ruby mat.rb

require 'rubygems'
require 'sinatra'
require 'config/environment'
require 'rubygems'
require 'sparql/client'
require 'linkeddata'
require 'calais'
require 'lib/parser'
include RDF


CALAIS_KEY = "rx2mtr6hxrgdnuxefy2jy2zc"

get "/" do
  "Hello. Welcome to semantic summer."  
end


get "/enlighten" do 
  content_type :xml
  text =  "Al Gore , Tiger Woods, and the government of the United Kingdom has given corporations like fast food chain McDonald's the right to award high school qualifications to employees who complete a company training program."
  newText = Nokogiri::XML(Calais.enlighten(
      :content => text,
      :content_type => :raw,
      :license_id => CALAIS_KEY ))
  "#{newText.to_xml}" 
end



post "/enlighten" do 
  content_type :xml
  text =  request.body.read
  newText = Calais.enlighten(
      :content => text,
      :content_type => :raw,
      :license_id => CALAIS_KEY )
      puts newText    
  #parser = Parser.new(newText)
  #{}"#{parser.get_dbpedia_rdf}"
  "#{newText}"
end



get "/process" do
  content_type :xml
  text =  "Al Gore , Tiger Woods, and the government of the United Kingdom has given corporations like fast food chain McDonald's the right to award high school qualifications to employees who complete a company training program."
  newText = Calais.process_document(
      :content => text,
      :content_type => :raw,
      :license_id => CALAIS_KEY )
  "#{newText.inspect}"
  
  
end 


get "/dbpedia" do
  DBPEDIA_SPARQL
end


get "/dbpedia/person/:id" do
  output = ""
 
end
