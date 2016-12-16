require "spec_helper"

describe Docker::Swarm::Compose do
  it "has a version number" do
    expect(Docker::Swarm::Compose::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
