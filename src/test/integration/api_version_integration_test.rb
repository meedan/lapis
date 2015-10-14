require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'test_helper')

class ApiVersionIntegrationTest < ActionDispatch::IntegrationTest
  test "should recognize route" do
    assert_recognizes({ controller: 'api/v1/test', action: 'test', format: 'json' }, { path: 'api/test', method: :get })
  end
end
