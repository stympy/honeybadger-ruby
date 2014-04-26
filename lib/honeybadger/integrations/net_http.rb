class Net::HTTP
  def request_with_honeybadger(*args, &block)
    request = args[0]
    uri = request.path.match(%r{https?://}) ? URI(request.path) : URI("http#{use_ssl? ? 's' : ''}://#{address}:#{port}#{request.path}")
    payload = { uri: uri, method: request.method }
    ActiveSupport::Notifications.instrument("net_http.request", payload) do
      request_without_honeybadger(*args, &block)
    end
  end
  alias request_without_honeybadger request
  alias request request_with_honeybadger
end
