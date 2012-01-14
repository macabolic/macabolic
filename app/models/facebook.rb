require 'httparty'
class Facebook
    include HTTParty
    base_uri 'https://graph.facebook.com/' #https://graph.facebook.com/me/friends?access_token=AAAAAAITEghMBAHAek9yKuw1WyEGUmB15ovKZBeTA2fVm395hTlYxxWWuIA8rTKEBvm5HYh9m59yDC3ZBARqTQFVJ7Y94NPoqf31Ar9FAZDZD
    # default_params :output => 'json'
    format :json

    def self.object(id)
        get "/#{id}"
    end
end
