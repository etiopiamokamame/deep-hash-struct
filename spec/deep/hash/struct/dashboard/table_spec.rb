require "spec_helper"

describe Deep::Hash::Struct::Dashboard::Table do
  before do
    @options = {}
  end

  let(:options) { @options }
  let(:table) { described_class.new options }

  describe "#matrix?" do
    context "When there is a matrix option" do
      before do
        options[:matrix] = true
      end

      it "Return true" do
        expect(table.matrix?).to be_truthy
      end
    end

    context "When there is no matrix option" do
      it "Return false" do
        expect(table.matrix?).to be_falsey
      end
    end
  end

  describe "#add_header" do
    it "Add header to segment table" do
      table.add_header do |h|
        h.a = "header1"
        h.b = "header2"
        h.c = "header3"
      end

      expect(table.header.to_h).to eq({ a: "header1", b: "header2", c: "header3" })
    end

    it "Add header to matrix table" do
      options[:matrix]      = true
      options[:side_header] = "side_header"

      table.add_header do |h|
        h.a = "header1"
        h.b = "header2"
        h.c = "header3"
      end

      expect(table.header.to_h).to eq({ side_header: "side_header", a: "header1", b: "header2", c: "header3" })
    end
  end

  describe "#add_side" do
    before do
      options[:matrix] = true

      table.add_side do |h|
        h.a = "side1"
        h.b = "side2"
        h.c = "side3"
      end
    end

    it "Add side to matrix table" do
      expect(table.side.to_h).to eq({ a: "side1", b: "side2", c: "side3" })
    end
  end

  describe "#add_body" do
    it "Add body to matrix table" do
      table.add_body do |row|
        row.a.a = 1
        row.a.b = 2
        row.b.a = 3
      end

      expect(table.body.map(&:to_h)).to eq([{ a: { a: 1, b: 2 }, b: { a: 3 } }])
    end

    it "Add body to segment table" do
      table.add_body do |row|
        row.a = 1
      end
      table.add_body do |row|
        row.b = 2
      end
      table.add_body do |row|
        row.c = 3
      end

      expect(table.body.map(&:to_h)).to eq([{ a: 1 }, { b: 2 }, { c: 3 }])
    end
  end

  describe "#parse!" do
    context "When the header is undefined" do
      it "Header undefined error occurs" do
        expect { table.parse! }.to raise_error(Deep::Hash::Struct::Error::UndefinedHeader)
      end
    end

    context "When side is undefined in matrix table" do
      before do
        options[:matrix] = true
        table.add_header { |h| h.a = "header" }
      end

      it "Side undefined error occurs" do
        expect { table.parse! }.to raise_error(Deep::Hash::Struct::Error::UndefinedSide)
      end
    end

    context "When the header hierarchy is irregular" do
      before do
        table.add_header do |h|
          h.a   = 1
          h.b.a = 2
        end
      end

      it "Incorrect header error occurs" do
        expect { table.parse! }.to raise_error(Deep::Hash::Struct::Error::InvalidHeader)
      end
    end

    context "When side hierarchy is irregular" do
      before do
        options[:matrix] = true
        table.add_header { |h| h.a = "header" }
        table.add_side do |h|
          h.a   = 1
          h.b.a = 2
        end
      end

      it "Incorrect side error occurs" do
        expect { table.parse! }.to raise_error(Deep::Hash::Struct::Error::InvalidSide)
      end
    end

    context "When there is a side in the segment table" do
      before do
        table.add_header { |h| h.a = "header" }
        table.add_side { |h| h.a = "side" }
      end

      it "Side unnecessary error occurs" do
        expect { table.parse! }.to raise_error(Deep::Hash::Struct::Error::UnnecessarySide)
      end
    end

    context "If you specify a header that does not exist in matrix table" do
      before do
        options[:matrix] = true
        table.add_header do |h|
          h.a = "header"
        end
        table.add_side do |s|
          s.a = "side"
        end
        table.add_body do |row|
          row.b.a = 1
        end
      end

      it "Header and body related errors occur" do
        expect { table.parse! }.to raise_error(Deep::Hash::Struct::Error::HeaderRelated)
      end
    end

    context "If you specify a side that does not exist" do
      before do
        options[:matrix] = true
        table.add_header do |h|
          h.a = "header"
        end
        table.add_side do |s|
          s.a = "side"
        end
        table.add_body do |row|
          row.a.b = 1
        end
      end

      it "Header and body related errors occur" do
        expect { table.parse! }.to raise_error(Deep::Hash::Struct::Error::HeaderRelated)
      end
    end

    context "If you specify a header that does not exist in segment table" do
      before do
        table.add_header do |h|
          h.a = "header"
        end
        table.add_body do |row|
          row.b = 1
        end
      end

      it "Header and body related errors occur" do
        expect { table.parse! }.to raise_error(Deep::Hash::Struct::Error::HeaderRelated)
      end
    end
  end

  describe "#each" do
    before do
      table.rows = expected
    end

    let(:expected) { [1, 2, 3] }

    it "each statement like hash" do
      index = 0
      table.each do |t|
        expect(t).to eq(expected[index])
        index += 1
      end
      expect(index).to eq(expected.size)
    end

    it "Omitting the block returns the Enumerator class" do
      index = 0
      table.each.with_index(1) do |t, i|
        expect(t).to eq(expected[index])
        expect(i).to eq(index + 1)
        index += 1
      end
      expect(index).to eq(expected.size)
    end
  end

  describe "#map" do
    before do
      table.rows = expected
    end

    let(:expected) { [1, 2, 3] }

    it "each statement like hash" do
      result = table.map do |t|
        t.to_s
      end
      expect(result).to eq(expected.map(&:to_s))
    end

    it "Omitting the block returns the Enumerator class" do
      result = table.map.each_with_index do |t, i|
        [t, i]
      end
      expect(result).to eq([[1, 0], [2, 1], [3, 2]])
    end
  end

  describe "#collect" do
    before do
      table.rows = expected
    end

    let(:expected) { [1, 2, 3] }

    it "each statement like hash" do
      result = table.collect do |t|
        t.to_s
      end
      expect(result).to eq(expected.map(&:to_s))
    end

    it "Omitting the block returns the Enumerator class" do
      result = table.collect.each_with_index do |t, i|
        [t, i]
      end
      expect(result).to eq([[1, 0], [2, 1], [3, 2]])
    end
  end

  describe "#tr" do
    context "Add header for String value" do
      before do
        table.tr do |tr|
          tr.th "A"
          tr.th "B"
          tr.th "C"
        end
      end

      it "Add header" do
        expect(table.header.values).to eq(%w(A B C))
        expect(table.body.count).to    be_zero
      end
    end

    context "Add header for Hash key value" do
      before do
        table.tr do |tr|
          tr.th({ key: "a", value: "A" })
          tr.th({ key: "b", value: "B" })
          tr.th({ key: "c", value: "C" })
        end
      end

      it "Add header" do
        expect(table.header.to_h).to eq({ a: "A", b: "B", c: "C" })
        expect(table.body.count).to  be_zero
      end
    end

    context "Add header for Hash" do
      before do
        table.tr do |tr|
          tr.th a: "A"
          tr.th b: "B"
          tr.th c: "C"
        end
      end

      it "Add header" do
        expect(table.header.to_h).to eq({ a: "A", b: "B", c: "C" })
        expect(table.body.count).to  be_zero
      end
    end

    context "Add body for string value" do
      before do
        table.tr do |tr|
          tr.td "A"
          tr.td "B"
          tr.td "C"
        end
      end

      it "Add body" do
        expect(table.body[0].values).to eq(%w(A B C))
        expect(table.body.count).to     eq(1)
      end
    end

    context "Add body for Hash key value" do
      before do
        table.tr do |tr|
          tr.td({ key: "a", value: "A" })
          tr.td({ key: "b", value: "B" })
          tr.td({ key: "c", value: "C" })
        end
      end

      it "Add body" do
        expect(table.body[0].to_h).to eq({ a: "A", b: "B", c: "C" })
        expect(table.body.count).to   eq(1)
      end
    end

    context "Add body for Hash" do
      before do
        table.tr do |tr|
          tr.td a: "A"
          tr.td b: "B"
          tr.td c: "C"
        end
      end

      it "Add body" do
        expect(table.body[0].to_h).to eq({ a: "A", b: "B", c: "C" })
        expect(table.body.count).to   eq(1)
      end
    end
  end
end
