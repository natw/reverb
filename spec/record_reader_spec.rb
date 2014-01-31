require 'spec_helper'

describe RecordReader do
  describe '.run' do
    it "exits if you don't supply any filenames" do
      expect{ RecordReader.run([]) }.to raise_error(SystemExit)
    end

    it "reads some records" do
      RecordReader.stub(:parse_files).with(['foo', 'bar']).and_return([['a', 'b', 'c', 'd', '1/2/3']])
      RecordReader.stub(:display) { |x| x }
      RecordReader.run(['foo', 'bar', '-o', '1'])
    end

  end

  describe '.guess_separator' do
    it "can error out" do
      expect{ RecordReader.guess_separator('hey there') }.to raise_error
    end

    context "a reasonable csv" do
      let (:data) { 'asdf, qwerty, foo\, bar, baz, qux' }

      it 'sees the commas' do
        expect(RecordReader.guess_separator(data)).to eq ','
      end
    end

    context "a reasonable psv" do
      let (:data) { 'asdf | qwerty | foo \| bar | baz | qux' }

      it "returns a pipe" do
        expect(RecordReader.guess_separator(data)).to eq '|'
      end
    end

    context "a reasonable space separated value file" do
      let (:data) { 'asdf qwerty foo\ bar baz qux' }

      it "returns a space" do
        expect(RecordReader.guess_separator(data)).to eq ' '
      end
    end

    context "a tricky csv" do
      let (:data) { 'a | a, b | b, c | c, d | d, e' }

      it "should recognize a csv" do
        expect(RecordReader.guess_separator(data)).to eq ','
      end
    end
  end
end
