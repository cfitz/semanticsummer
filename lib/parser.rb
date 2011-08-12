require 'rubygems'
require 'nokogiri'
require 'rubygems'
require 'sparql/client'
require 'linkeddata'
require 'calais'
require 'lib/parser'
require 'rest-client'

include RDF



class Parser
  
  attr_accessor :xml
  attr_accessor :end_graph  
  attr_accessor :uris
  
  def initialize(xml)    
    @end_graph = RDF::Graph.new
    @xml = Nokogiri::XML(xml)
    @uris = []
  end
  
  def build_graph
   graph = get_calais_uris 
   graph.statements.each { |s| @end_graph << get_sameAs(s.subject)   }
   @uris.each { |statement| @end_graph << get_enrichment(statement) } 
    
  end
  
  
  def get_sameAs(subject)
        rdf = request(subject.to_s)
        unless rdf.nil?
          graph = RDF::Graph.new
          graph << RDF::Reader.for(:content_type =>  "application/rdf+xml" ).new(rdf)
          graph.query([subject, OWL.sameAs, nil]) do |statement|
            @uris << statement
            @end_graph << statement
          end
        end
  end
    
  def get_enrichment(statement)
    enriched_graph = RDF::Graph.new
    enriched_graph << RDF::Reader.for(:content_type =>  "application/rdf+xml" ).new(request(statement.object.to_s))
  
  
  end
  
  
private
  
  def get_calais_uris
    graph = RDF::Graph.new
    graph << RDF::Reader.for(:content_type =>  "application/rdf+xml" ).new(@xml)
    
    
    calaisEM = RDF::Vocabulary.new("http://s.opencalais.com/1/type/em/e/")
    calaisER = RDF::Vocabulary.new("http://s.opencalais.com/1/type/er/")
    
    graph.query([ nil, RDF.type, calaisEM.Person]) { |statement| @end_graph << statement }
    graph.query([ nil, RDF.type, calaisER.Company]) { |statement| @end_graph << statement }
    graph.query([ nil, RDF.type, calaisEM.Organization]) { |statement| @end_graph << statement }
    return @end_graph.dup
  end
  
  def request(uri)
    rdf = RestClient.get uri, { :accept => "application/rdf+xml", :timeout => 90000000 } 
    return rdf
  rescue  RestClient::RequestTimeout => e
    puts "#{uri} \n #{e}"
  end
  
  
end

