# frozen_string_literal: true
require '../spec_helper.rb'

CLIENT = Twitter::Client.new(access_token: CREDENTIALS['access_token'])
tags = '#food'

describe 'Twitter::Tweet::search' do

  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<ACCESS_TOKEN>') { CREDENTIALS[:access_token] }
    c.filter_sensitive_data('<ACCESS_TOKEN_ESCAPED>') do
      URI.parse(URI.encode(CREDENTIALS[:access_token].to_s))
      #URI.escape(CREDENTIALS[:access_token])
    end
  end

  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes

    @CLIENT = Twitter::Client.new(
      access_token: CREDENTIALS[:access_token]
    )
    @CLIENT.search_tweets(tags)
    
  end

  after do
    VCR.eject_cassette
  end


  it 'should return Tweets that contain specific hashtags' do
    tweets = Twitter::Tweet.search(tags, using_client: CLIENT)
    tweets.length.must_be :>, 0
  end
end
