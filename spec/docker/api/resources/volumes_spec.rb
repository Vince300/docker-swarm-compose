require "spec_helper"


describe Docker::Api::Resources::Volumes do
  before :all do
    @client = Docker::Api::Client.new
  end

  describe "#volumes" do
    before :all do
      @volumes = []
      2.times do |v|
        @volumes << @client.volume_create
      end
    end

    it "returns a VolumeListResponse" do
      expect(@client.volumes).to be_a(Docker::Api::VolumeListResponse)
    end

    it "defaults to no filters" do
      volumes = @client.volumes.volumes
      @volumes.each do |volume|
        expect(volumes).to include(named_object volume)
      end
    end

    it "accepts filters" do
      volumes = @client.volumes(name: [@volumes.first.name]).volumes
      expect(volumes).to include(named_object @volumes[0])
      expect(volumes).not_to include(named_object @volumes[1])
    end

    after :all do
      @volumes.each(&:remove)
    end
  end

  describe "#volume_create" do
    it "creates volumes" do
      volume = @client.volume_create

      expect(@client.volumes.volumes).to include(named_object volume.name)

      volume.remove
    end
  end

  describe "#volume_inspect" do
    it "inspects volumes" do
      volume = @client.volume_create

      expect(@client.volume_inspect(volume.name).driver).to eq(volume.driver)

      volume.remove
    end
  end

  describe "#volume_remove" do
    it "removes volumes" do
      volume = @client.volume_create

      @client.volume_remove(volume.name)

      expect(@client.volumes.volumes).not_to include(named_object volume.name)
    end
  end
end