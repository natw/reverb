require 'spec_helper'

describe Reverb::RecordReader do
  describe '.run' do
    let (:records) {
      [
        {last_name: 'a', birthday: Date.new(4,5,6), sex: 'M'},
        {last_name: 'o', birthday: Date.new(5,6,7), sex: 'M'},
        {last_name: 'l', birthday: Date.new(3,4,5), sex: 'F'},
        {last_name: 'x', birthday: Date.new(7,8,9), sex: 'F'},
      ]
    }

    it "exits if you don't supply any filenames" do
      expect{ subject.run([]) }.to raise_error(SystemExit)
    end

    it "reads some records" do
      subject.stub(:parse_files).with(['foo', 'bar']).and_return(records)
      subject.stub(:display) { |x| x }
      subject.run(['foo', 'bar', '-o', '1'])
    end
  end

  describe '.getopts' do
    it 'parses the output style' do
      expect(subject.getopts(['foo', 'bar', '--output', '3'])).to eq({output: 3})
    end

    it 'also recognizes the short version' do
      expect(subject.getopts(['-o', '2', 'foo', 'bar'])).to eq({output: 2})
    end
  end

  describe '.sort' do
    let (:records) {
      [
        {last_name: 'a', birthday: Date.new(4,5,6), sex: 'M'},
        {last_name: 'o', birthday: Date.new(5,6,7), sex: 'M'},
        {last_name: 'l', birthday: Date.new(3,4,5), sex: 'F'},
        {last_name: 'x', birthday: Date.new(7,8,9), sex: 'F'},
      ]
    }
    context 'style 1' do
      let (:style) { 1 }

      it 'sorts by gender, then last name ascending' do
        expect(subject.sort(records, style)).to eq(
          [records[2], records[3], records[0], records[1]]
        )
      end
    end

    context 'style 2' do
      let (:style) { 2 }

      it 'sorts by birth date ascending' do
        expect(subject.sort(records, style)).to eq(
          [records[2], records[0], records[1], records[3]]
        )
      end
    end

    context 'style 3' do
      let (:style) { 3 }

      it 'sorts by last name descending' do
        expect(subject.sort(records, style)).to eq(
          [records[3], records[1], records[2], records[0]]
        )
      end
    end

    context 'something else' do
      it 'aborts' do
        expect{subject.sort(records, 4)}.to raise_error(SystemExit)
      end
    end
  end

  describe '.display' do
    let (:records) {
      [
        {last_name: 'a', first_name: 'asdf', favorite_color: 'red', birthday: Date.new(4,5,6), sex: 'M'},
        {last_name: 'o', first_name: 'asdf', favorite_color: 'red', birthday: Date.new(5,6,7), sex: 'M'},
        {last_name: 'l', first_name: 'asdf', favorite_color: 'red', birthday: Date.new(3,4,5), sex: 'F'},
        {last_name: 'x', first_name: 'asdf', favorite_color: 'red', birthday: Date.new(7,8,9), sex: 'F'},
      ]
    }

    it "putses some strings" do
      expect(subject).to receive(:puts).exactly(4).times
      subject.display(records)
    end
  end

  describe '.parse_files' do
    it 'returns parsed rows, flattened' do
      expect(subject).to receive(:parse_file).with('a').ordered { [1,2,3] }
      expect(subject).to receive(:parse_file).with('b').ordered { [4,5,6] }
      expect(subject.parse_files(['a', 'b'])).to eq [1, 2, 3, 4, 5, 6]
    end
  end

  describe '.parse_file' do
    it 'parses a file' do
      expect(File).to receive(:new).with('filename') { double(read: 'asdf') }
      expect(Reverb::RecordParser).to receive(:new).with('asdf') { double(hashes: 'parsed') }
      expect(subject.parse_file('filename')).to eq('parsed')
    end
  end
end
