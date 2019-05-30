require "rspec"

RSpec.describe Deep::Hash::Struct::Dashboard::Table::Tr do
  before do
    @options = {}
  end

  let(:options) { @options }
  let(:header) { Deep::Hash::Struct::Wrapper.new }
  let(:body) { Deep::Hash::Struct::Wrapper.new }
  let(:side) { Deep::Hash::Struct::Wrapper.new }
  let(:tr) { described_class.new header, body, side, options }

  describe "#th" do
    context "When add header for String value" do
      before do
        tr.th "a"
        tr.th "b"
        tr.th "c"
      end

      it "Add header" do
        expect(tr.header.to_h).to eq({ key_1: "a", key_2: "b", key_3: "c" })
      end
    end

    context "When add header for Hash key value" do
      before do
        tr.th({ key: :a, value: "a" })
        tr.th({ key: :b, value: "b" })
        tr.th({ key: :c, value: "c" })
      end

      it "Add header" do
        expect(tr.header.to_h).to eq({ a: "a", b: "b", c: "c" })
      end
    end

    context "When add header for Hash" do
      before do
        tr.th a: "a"
        tr.th b: "b"
        tr.th c: "c"
      end

      it "Add header" do
        expect(tr.header.to_h).to eq({ a: "a", b: "b", c: "c" })
      end
    end

    context "When add side header" do
      before do
        options[:side] = true
        tr.th "a"
        tr.th "b"
        tr.th "c"
      end

      it "Add side" do
        expect(tr.side.to_h).to eq({ key_1: "a", key_2: "b", key_3: "c" })
      end
    end
  end

  describe "#td" do
    context "When add body for Strong value" do
      before do
        tr.td "a"
        tr.td "b"
        tr.td "c"
      end

      it "Add body" do
        expect(tr.body.to_h).to eq({ key_1: "a", key_2: "b", key_3: "c" })
      end
    end

    context "When add body for Hash key value" do
      before do
        tr.td(key: :a, value: "a")
        tr.td(key: :b, value: "b")
        tr.td(key: :c, value: "c")
      end

      it "Add body" do
        expect(tr.body.to_h).to eq({ a: "a", b: "b", c: "c" })
      end
    end

    context "When add body for Hash" do
      before do
        tr.td a: "a"
        tr.td b: "b"
        tr.td c: "c"
      end

      it "Add body" do
        expect(tr.body.to_h).to eq({ a: "a", b: "b", c: "c" })
      end
    end

    context "When ther is a side and b_index 1 options" do
      before do
        options[:side]    = true
        options[:b_index] = 1
        tr.header.a = 1
        tr.header.b = 2
        tr.header.c = 3
        tr.side.d   = 4
        tr.side.e   = 5
        tr.side.f   = 6

        tr.td "a"
        tr.td "b"
        tr.td "c"
      end

      it "Add body in e side" do
        expect(tr.body.values.map(&:to_h)).to eq([{ e: "a" }, { e: "b" }, { e: "c" }])
      end
    end
  end
end
