require_relative '../application'

def send_request(http_method, url)
  Application.application.call({'PATH_INFO' => url, 'REQUEST_METHOD' => http_method.upcase})
end

describe Application do
  context 'Check responses for request' do
    before :all do
      Application.reset

      get '/articles' do
        'articles#index'
      end

      get '/articles/1' do
        'articles#show'
      end

      get '/articles/new' do
        'articles#new'
      end

      post '/articles' do
        'articles#create'
      end

      get '/articles/1/edit' do
        'articles#edit'
      end

      put '/articles/1' do
        'articles#update'
      end

      patch '/articles/1' do
        'articles#partial_update'
      end

      delete '/articles/1' do
        'articles#destroy'
      end

      @response_headers =  { "Content-Type" => "text/html" }
    end

    after :all do
      Application.reset
    end

    context 'for existing routes' do
      it '#get' do
        expect(send_request('get', '/articles')).to eq([200, @response_headers, ['articles#index']])
        expect(send_request('get', '/articles/1')).to eq([200, @response_headers, ['articles#show']])
        expect(send_request('get', '/articles/new')).to eq([200, @response_headers, ['articles#new']])
        expect(send_request('get', '/articles/1/edit')).to eq([200, @response_headers, ['articles#edit']])
      end

      it '#post' do
        expect(send_request('post', '/articles')).to eq([200, @response_headers, ['articles#create']])
      end

      it '#put' do
        expect(send_request('put', '/articles/1')).to eq([200, @response_headers, ['articles#update']])
      end

      it '#patch' do
        expect(send_request('patch', '/articles/1')).to eq([200, @response_headers, ['articles#partial_update']])
      end

      it '#delete' do
        expect(send_request('delete', '/articles/1')).to eq([200, @response_headers, ['articles#destroy']])
      end
    end

    it 'for missing routes' do
      expect(send_request('put', '/test')).to eq([404, @response_headers, ["Page not found"]])
      expect(send_request('put', '/articles')).to eq([404, @response_headers, ["Page not found"]])
      expect(send_request('delete', '/articles')).to eq([404, @response_headers, ["Page not found"]])
      expect(send_request('put', '/articles/1/test')).to eq([404, @response_headers, ["Page not found"]])
    end
  end
end
