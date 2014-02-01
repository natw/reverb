require 'spec_helper'

describe Reverb::RecordParser do
  describe '#hashes' do
    let (:rows) {
      [['Parker', 'Peter', 'M', 'red', "2000/1/2/"]]
    }

    it "builds hashes out of the parsed rows" do
      parser = Reverb::RecordParser.new(nil)
      expect(parser).to receive(:parse) { rows }
      expect(parser.hashes).to eq(
        [{last_name: 'Parker', first_name: 'Peter', sex: 'M',
          favorite_color: 'red', birthday: Date.new(2000, 1, 2)}]
      )
    end
  end

  describe 'separator' do
    subject do
      Reverb::RecordParser.new(data)
    end

    context "bad data" do
      let (:data) { 'hey there' }

      it "will error out" do
        expect{ subject.separator }.to raise_error(RuntimeError)
      end
    end

    context "a reasonable csv" do
      let (:data) { 'asdf, qwerty, foo\, bar, baz, qux' }

      it 'sees the commas' do
        expect(subject.separator).to eq ','
      end
    end

    context "a reasonable psv" do
      let (:data) { 'asdf | qwerty | foo \| bar | baz | qux' }

      it "returns a pipe" do
        expect(subject.separator).to eq '|'
      end
    end

    context "a reasonable space separated value file" do
      let (:data) { 'asdf qwerty foo\ bar baz qux' }

      it "returns a space" do
        expect(subject.separator).to eq ' '
      end
    end

    context "a tricky csv" do
      let (:data) { 'a | a, b | b, c | c, d | d, e' }

      it "should recognize a csv" do
        expect(subject.separator).to eq ','
      end
    end
  end
end
