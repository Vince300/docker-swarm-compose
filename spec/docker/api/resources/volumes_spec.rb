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

    it "accepts filters" do
      filter = { 'name': [@volumes.first.name] }
      [ filter, JSON.dump(filter) ].each do |f|
        volumes = @client.volumes(filters: f).volumes
        expect(volumes).to include(named_object @volumes[0].name)
        expect(volumes).not_to include(named_object @volumes[1].name)
      end
    end

    it "warns on invalid filters" do
      expect(@client).to receive(:warn).with("unexpected type for :filters parameter (Fixnum)")

      # TODO: Use specific exception when implemented
      expect { @client.volumes(filters: 1) }.to raise_error
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