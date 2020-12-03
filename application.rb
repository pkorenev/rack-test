class Application
  HTTP_METHOD_NAMES = %w(get post put patch delete)

  def self.application
    @application ||= Application.new
  end

  def self.reset
    @application = Application.new
  end

  def initialize
    @routes = []
  end

  HTTP_METHOD_NAMES.each do |method_name|
    define_method method_name do |url, &block|
      @routes << {url: url, method: method_name.upcase, action: block}
    end
  end

  def call(env)
    handle_request(env['PATH_INFO'], env['REQUEST_METHOD'])
  end

  private

  def handle_request(url, method)
    if route = find_route(url, method)
      response_body = route[:action].call || ''
      status  = 200
      headers = { "Content-Type" => "text/html" }
      body    = [response_body]
    else
      status  = 404
      headers = { "Content-Type" => "text/html" }
      body    = ["Page not found"]
    end

    [status, headers, body]
  end

  def find_route(url, method)
    @routes.find { |route| route[:url] == url && route[:method] == method }
  end
end

Application::HTTP_METHOD_NAMES.each do |method_name|
  define_method method_name do |url, &block|
    Application.application.send(method_name, url, &block)
  end
end
