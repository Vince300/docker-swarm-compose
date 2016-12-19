require "spec_helper"

describe URI::UNIX do
  it "parses unix:///my/test.sock:/hello?hello=true" do
    url = URI('unix:///my/test.sock:/hello?hello=true')

    expect(url.socket_path).to eq('/my/test.sock')
    expect(url.path).to eq('/hello')
    expect(url.request_uri).to eq('/hello?hello=true')
  end
end
