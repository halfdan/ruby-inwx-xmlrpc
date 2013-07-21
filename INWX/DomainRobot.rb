=begin
Created on 2010/03/20

@author: Fabian Becker
@email: halfdan@xnorfz.de

DomainRobot API interface
=end

require "xmlrpc/client"
require "digest/sha2"

module INWX
  class DomainRobot
    attr_accessor :address, :username, :password, :language, :secure
    
    def initialize(address, username = false, password = false, language = 'en', secure = false)
      @address = address
      @username = username
      @password = password
      @language = language
      @secure = secure
    end
    
    def call(object, method, params = {})
      if self.secure 
        # Get a one-time-"random" nonce
        nonce = Time.now.to_f
        
        # Generate hash from nonce and password.
        hash = Digest::SHA2.new(bitlen = 256) << nonce.to_s + self.password.to_s
        
        # Merge both into params
        params.merge! :nonce => nonce.to_s, :pass => hash.to_s        
      else               
        params.merge! :pass => self.password
      end
      
      # Merge username into params
      params.merge! :user => self.username
     
      # Create a new client instance
      client = XMLRPC::Client.new(self.address, "/xmlrpc/" + object, "443", nil, nil, nil, nil, true, 900)
      
      # Call the remote method
      client.call(method, params)
    end
  end
end
