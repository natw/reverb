require 'spec_helper'

describe 'guess_separator' do
  it "can error out" do
    expect{ guess_separator('hey there') }.to raise_error
  end

  context "a reasonable csv" do
    let (:data) {
      'asdf, qwerty, foo\, bar, baz, qux'
    }

    it 'sees the commas' do
      expect(guess_separator(data)).to eq ','
    end
  end

  context "a reasonable psv" do
    let (:data) {
      'asdf | qwerty | foo \| bar | baz | qux'
    }

    it "returns a pipe" do
      expect(guess_separator(data)).to eq '|'
    end
  end

  context "a reasonable space separated value file" do
    let (:data) {
      'asdf qwerty foo\ bar baz qux'
    }

    it "returns a space" do
      expect(guess_separator(data)).to eq ' '
    end
  end

  context "a tricky csv" do
    let (:data) {
      'a | a, b | b, c | c, d | d, e'
    }

    it "should recognize a csv" do
      expect(guess_separator(data)).to eq ','
    end
  end
end
