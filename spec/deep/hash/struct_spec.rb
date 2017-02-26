require "spec_helper"

describe Deep::Hash::Struct do
  it "has a version number" do
    expect(Deep::Hash::Struct::VERSION).not_to be nil
  end

  let(:wrapper) { Deep::Hash::Struct::Wrapper.new }

  describe "#initialize" do
    before do
      expected = {
        one: 1,
        two: {
          one: 2,
          two: 3
        },
        three: {
          one: 4,
          two: {
            one: 5,
            two: 6
          },
          three: {
            one:   7,
            two:   8,
            three: 9
          }
        }
      }
      @init_wrapper = Deep::Hash::Struct::Wrapper.new(expected)
    end

    let(:init_wrapper) { @init_wrapper }

    it "initial setting" do
      expect(init_wrapper.one).to               eq(1)
      expect(init_wrapper.two.one).to           eq(2)
      expect(init_wrapper.two.two).to           eq(3)
      expect(init_wrapper.three.one).to         eq(4)
      expect(init_wrapper.three.two.one).to     eq(5)
      expect(init_wrapper.three.two.two).to     eq(6)
      expect(init_wrapper.three.three.one).to   eq(7)
      expect(init_wrapper.three.three.two).to   eq(8)
      expect(init_wrapper.three.three.three).to eq(9)
    end
  end

  describe "#keys" do
    before do
      @added_one_wrapper = wrapper.dup
      @added_one_wrapper.key

      @added_some_wrapper = wrapper.dup
      @added_some_wrapper.one
      @added_some_wrapper.two
      @added_some_wrapper.three
    end

    let(:added_one_wrapper) { @added_one_wrapper }

    let(:added_some_wrapper) { @added_some_wrapper }

    it "returns empty array" do
      expect(wrapper.keys).to eq([])
    end

    it "returns one item array" do
      expect(added_one_wrapper.keys).to eq([:key])
    end

    it "returns some items array" do
      expect(added_some_wrapper.keys).to eq(%i(one two three))
    end
  end

  describe "#[]" do
    before do
      wrapper.key = "abc"
      wrapper.empty
    end

    it "returns wrapper instance" do
      expect(wrapper.empty).to be_a(wrapper.class)
    end

    context "when called with a symbol" do
      it "returns assigned value" do
        expect(wrapper[:key]).to  eq("abc")
      end
    end

    context "when called with a string" do
      it "returns assigned value" do
        expect(wrapper["key"]).to eq("abc")
      end
    end

    context "when calls with undeclared key" do
      it "returns wrapper instance" do
        expect(wrapper.undeclared).to be_a(wrapper.class)
      end
    end
  end

  describe "#merge" do
    before do
      wrapper.one     = 1
      wrapper.two.one = 2
      wrapper.two.two = 3

      @merge_data = {
        one:   11,
        two:   22,
        three: {
          one:   1,
          two:   2,
          three: 3
        }
      }
    end

    let(:merge_wrapper) { wrapper.merge(@merge_data) }

    it "temporarily overwrite data" do
      expect(wrapper.one).to               eq(1)
      expect(wrapper.two.one).to           eq(2)
      expect(wrapper.two.two).to           eq(3)
      expect(merge_wrapper.one).to         eq(11)
      expect(merge_wrapper.two).to         eq(22)
      expect(merge_wrapper.three.one).to   eq(1)
      expect(merge_wrapper.three.two).to   eq(2)
      expect(merge_wrapper.three.three).to eq(3)
    end
  end

  describe "#merge!" do
    before do
      wrapper.one     = 1
      wrapper.two.one = 2
      wrapper.two.two = 3

      @merge_data = {
        one:   11,
        two:   22,
        three: {
          one:   1,
          two:   2,
          three: 3
        }
      }
      wrapper.merge!(@merge_data)
    end

    it "completely overwrite data" do
      expect(wrapper.one).to         eq(11)
      expect(wrapper.two).to         eq(22)
      expect(wrapper.three.one).to   eq(1)
      expect(wrapper.three.two).to   eq(2)
      expect(wrapper.three.three).to eq(3)
    end
  end

  describe "#deep_merge" do
    before do
      wrapper.one         = 1
      wrapper.two.one     = 2
      wrapper.two.two     = 3
      wrapper.three.one   = 4
      wrapper.three.two   = 5
      wrapper.three.three = 6

      @merge_data = {
        one:   11,
        two:   {
          one: 22,
          two: 33
        },
        three: {
          one:   44,
          two:   55,
          three: 66
        }
      }
    end

    let(:merge_wrapper) { wrapper.deep_merge(@merge_data) }

    it "temporarily overwrite deep data" do
      expect(wrapper.one).to               eq(1)
      expect(wrapper.two.one).to           eq(2)
      expect(wrapper.two.two).to           eq(3)
      expect(wrapper.three.one).to         eq(4)
      expect(wrapper.three.two).to         eq(5)
      expect(wrapper.three.three).to       eq(6)
      expect(merge_wrapper.one).to         eq(11)
      expect(merge_wrapper.two.one).to     eq(22)
      expect(merge_wrapper.two.two).to     eq(33)
      expect(merge_wrapper.three.one).to   eq(44)
      expect(merge_wrapper.three.two).to   eq(55)
      expect(merge_wrapper.three.three).to eq(66)
    end
  end

  describe "#deep_merge!" do
    before do
      wrapper.one         = 1
      wrapper.two.one     = 2
      wrapper.two.two     = 3
      wrapper.three.one   = 4
      wrapper.three.two   = 5
      wrapper.three.three = 6

      @merge_data = {
        one:   11,
        two:   {
          one: 22,
          two: 33
        },
        three: {
          one:   44,
          two:   55,
          three: 66
        }
      }
      wrapper.deep_merge!(@merge_data)
    end

    it "completely overwrite deep data" do
      expect(wrapper.one).to         eq(11)
      expect(wrapper.two.one).to     eq(22)
      expect(wrapper.two.two).to     eq(33)
      expect(wrapper.three.one).to   eq(44)
      expect(wrapper.three.two).to   eq(55)
      expect(wrapper.three.three).to eq(66)
    end
  end

  describe "#fetch" do
    context "when the key exists" do
      before do
        wrapper.one = 1
      end

      it "returns the value of the key" do
        expect(wrapper.fetch(:one, :not_found)).to eq(1)
        expect(wrapper.fetch(:one) { |k| "#{k} not found" }).to eq(1)
      end
    end

    context "when the key does not exist" do
      it "returns the message" do
        expect(wrapper.fetch(:none)).to be nil
        expect(wrapper.fetch(:none, :not_found)).to eq(:not_found)
        expect(wrapper.fetch(:one) { |k| "#{k} not found" }).to eq("one not found")
      end
    end
  end
end
