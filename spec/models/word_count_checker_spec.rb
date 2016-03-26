require 'rails_helper'

RSpec.describe WordCountChecker do
  subject(:checker) { WordCountChecker.new('a ' * 15, 4) }

  describe '#actual' do
    it 'is the count of words' do
      expect(checker.actual).to eq(15)
      expect(WordCountChecker.new("howdy, y'all: she said").actual).to eq(4)
    end
  end

  describe '#expected' do
    it 'is 2 ^ level' do
      expect(checker.expected).to eq(16)
      expect(WordCountChecker.new('a', 1).expected).to eq(2)
      expect(WordCountChecker.new('a', 10).expected).to eq(1024)
    end
  end

  describe '#range' do
    it 'is a range within 10% of range' do
      expect(checker.range).to eq((15..17))
      expect(WordCountChecker.new('a', 1).range).to eq((2..2))
      expect(WordCountChecker.new('a', 10).range).to eq((922..1126))
    end
  end

  describe '#exact?' do
    context 'exact word count match' do
      subject { WordCountChecker.new('a b c d', 2).exact? }
      it { is_expected.to be(true) }
    end

    context 'close word count match' do
      subject { checker.exact? }
      it { is_expected.to be(false) }
    end

    context 'not close word count match' do
      subject { WordCountChecker.new('a b c', 2).exact? }
      it { is_expected.to be(false) }
    end

    context 'no level' do
      subject { WordCountChecker.new('a b').exact? }
      it { is_expected.to be(false) }
    end
  end

  describe '#match?' do
    context 'exact word count match' do
      subject { WordCountChecker.new('a b c d', 2).match? }
      it { is_expected.to be(true) }
    end

    context 'close word count match' do
      subject { checker.match? }
      it { is_expected.to be(true) }
    end

    context 'not match word count match' do
      subject { WordCountChecker.new('a b c', 2).match? }
      it { is_expected.to be(false) }
    end

    context 'no level' do
      subject { WordCountChecker.new('a b').match? }
      it { is_expected.to be(false) }
    end
  end

  describe '#type' do
    context 'exact word count match' do
      subject { WordCountChecker.new('a b c d', 2).type }
      it { is_expected.to be(:exact) }
    end

    context 'close word count match' do
      subject { checker.type }
      it { is_expected.to be(:close) }
    end

    context 'not match word count match' do
      subject { WordCountChecker.new('a b c', 2).type }
      it { is_expected.to be(:none) }
    end

    context 'no level' do
      subject { WordCountChecker.new('a b').type }
      it { is_expected.to be(:none) }
    end
  end

  describe '#to_hash' do
    it 'includes actual, expected, range and type' do
      expect(checker.to_hash).to eq({
        actual: 15, expected: 16, range: (15..17), type: :close
      })
    end

    context 'no level' do
      it 'includes actual only' do
        expect(WordCountChecker.new('a b').to_hash).to eq({actual: 2})
      end
    end
  end

  describe '.expected_for' do
    it 'is 2 ^ argument' do
      expect(WordCountChecker.expected_for(2)).to eq(4)
      expect(WordCountChecker.expected_for(9)).to eq(512)
    end
  end

  describe '.range_for' do
    it 'is a range of up to 10% above or below 2 ^ argument' do
      expect(WordCountChecker.range_for(2)).to eq((4..4))
      expect(WordCountChecker.range_for(3)).to eq((8..8))
      expect(WordCountChecker.range_for(4)).to eq((15..17))
      expect(WordCountChecker.range_for(5)).to eq((29..35))
    end
  end
end
