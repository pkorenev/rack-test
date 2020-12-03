require_relative '../application'

def send_request(http_method, url)
  Application.application.call({'PATH_INFO' => url, 'REQUEST_METHOD' => http_method.upcase})
end

describe 'Router' do
  before :all do
    Application.reset
    require_relative '../router'
    @response_headers =  { "Content-Type" => "text/html" }
  end

  after :all do
    Application.reset
  end

  context 'frank-says' do
    it '#get' do
      expect(send_request('get', '/frank-says')).to eq([200, @response_headers, ['I am GET']])
    end

    it '#post' do
      expect(send_request('post', '/frank-says')).to eq([200, @response_headers, ['I am POST']])
    end
  end

  context 'test' do
    it '#put' do
      expect(send_request('put', '/test')).to eq([200, @response_headers, ['I am test PUT']])
    end
  end
end
