require "spec_helper"
require "sse"

describe ServerSide::SSE do
  include ActionController::Live

  let!(:stream) { double ActionDispatch::Response::Buffer }
  let!(:sse) { ServerSide::SSE.new(stream) }
  describe "#initialize" do
    before do
      expect(ServerSide::SSE).to receive(:new).with(stream).once
    end
    it "creates the stream" do
      ServerSide::SSE.new(stream)
    end
  end

  describe "#write" do
    let(:object) {{ song: "song", loads: true }}
    let(:option) {{ event: "enter" }}
    before do
      stream.stub(:write).with(anything).and_return("written")
      expect(stream).to receive(:write).with("event: enter\n")
    end
    it "writes the stream" do
      sse.write(object, option)
    end
  end

  describe "#close" do
    before do
      stream.stub(:close) { "closed" }
      expect(stream).to receive(:close)
    end
    it "closes the stream" do
      sse.close
    end
  end
end
