require 'spec_helper'

describe 'guess_separator' do
  it "can error out" do
    expect{ guess_separator('hey there') }.to raise_error
  end
end
