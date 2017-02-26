require "spec_helper"

describe Deep::Hash::Struct do
  it "has a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  let(:wrapper) { described_class::Wrapper.new }

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
      @init_wrapper = described_class::Wrapper.new(expected)
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

  describe "Getter And Setter Methods" do
    it "valus setting and getting" do
      wrapper.a = 1
      expect(wrapper.a).to eq(1)
    end

    it "block setting" do
      wrapper.a do
        1 + 1
      end

      wrapper.b do
        params     = {}
        params[:a] = 1
        params[:b] = 2
        params[:c] = 3
        params
      end

      expect(wrapper.a).to      eq(2)
      expect(wrapper.b.to_h).to eq({ a: 1, b: 2, c: 3 })
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

    it "defined method" do
      expect(wrapper.respond_to?(:keys)).to be_truthy
    end

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

    it "defined method" do
      expect(wrapper.respond_to?(:[])).to be_truthy
    end

    it "returns wrapper instance" do
      expect(wrapper.empty).to be_a(wrapper.class)
    end

    context "when called with a symbol" do
      it "returns assigned value" do
        expect(wrapper[:key]).to eq("abc")
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

  describe "#[]=" do
    it "defined method" do
      expect(wrapper.respond_to?(:[]=)).to be_truthy
    end

    it "set value with a symbol" do
      wrapper[:key] = "abc"
      expect(wrapper[:key]).to eq("abc")
    end

    it "set value with a string" do
      wrapper["key"] = "abc"
      expect(wrapper[:key]).to eq("abc")
    end
  end

  describe "#==" do
    it "same config is true in my class" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3
      other     = wrapper.class.new
      other.a   = 1
      other.b   = 2

      expect(wrapper).not_to eq(other)

      other.c = 3

      expect(wrapper).to eq(other)
    end

    it "same config is true in hash" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3
      other     = {}
      other[:a] = 1
      other[:b] = 2

      expect(wrapper).not_to eq(other)

      other[:c] = 3

      expect(wrapper).to eq(other)
    end
  end

  describe "#===" do
    it "same class is true" do
      expect(wrapper === wrapper.class).to be_truthy
      expect(wrapper === Hash).to          be_falsey
    end
  end

  describe "#each" do
    it "defined method" do
      expect(wrapper.respond_to?(:each)).to be_truthy
    end

    it "each statement like hash" do
      expected_hash = {
        a: 1,
        b: 2,
        c: 3
      }
      expected_hash.each do |k, v|
        wrapper[k] = v
      end

      expected_count = 0
      wrapper.each do |k, v|
        expect(v).to eq(expected_hash[k])
        expected_count += 1
      end
      expect(expected_hash.size).to eq(expected_count)
    end

    it "Omitting the block returns the Enumerator class" do
      expected_hash = {
        a: 1,
        b: 2,
        c: 3
      }
      expected_hash.each do |k, v|
        wrapper[k] = v
      end

      expected_count = 0
      expected_index = 1

      expect(wrapper.each.class).to eq(Enumerator)
      wrapper.each.with_index(1) do |(k, v), i|
        expect(v).to eq(expected_hash[k])
        expect(i).to eq(expected_index)
        expected_count += 1
        expected_index += 1
      end
      expect(expected_hash.size).to eq(expected_count)
    end
  end

  describe "#each_with_index" do
    it "defined method" do
      expect(wrapper.respond_to?(:each_with_index)).to be_truthy
    end

    it "each.with_index statement like hash" do
      expected_hash = {
        a: 1,
        b: 2,
        c: 3
      }
      expected_hash.each do |k, v|
        wrapper[k] = v
      end

      expected_count = 0
      expected_index = 0
      wrapper.each_with_index do |(k, v), i|
        expect(v).to eq(expected_hash[k])
        expect(i).to eq(expected_index)
        expected_count += 1
        expected_index += 1
      end
      expect(expected_hash.size).to eq(expected_count)
    end
  end

  describe "#each_with_object" do
    it "defined method" do
      expect(wrapper.respond_to?(:each_with_object)).to be_truthy
    end

    it "returns the hash object" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3

      result = wrapper.each_with_object({}) do |(k, v), h|
        h[k.to_s] = v.class == wrapper.class ? v.to_h : [v]
      end

      expect(result).to eq("a" => [1], "b" => [2], "c" => { a: 3 })
    end
  end

  describe "#each_key" do
    it "defined method" do
      expect(wrapper.respond_to?(:each_key)).to be_truthy
    end

    it "each_key statement like hash" do
      expected_hash = {
        a: 1,
        b: 2,
        c: 3
      }
      expected_hash.each do |k, v|
        wrapper[k] = v
      end

      expected_count = 0
      wrapper.each_key do |k|
        expect(k).to eq(expected_hash.keys[expected_count])
        expected_count += 1
      end
      expect(expected_hash.size).to eq(expected_count)
    end
  end

  describe "#each_value" do
    it "defined method" do
      expect(wrapper.respond_to?(:each_value)).to be_truthy
    end

    it "each_value statement like hash" do
      expected  = [1, 2, 3]
      wrapper.a = expected[0]
      wrapper.b = expected[1]
      wrapper.c = expected[2]

      expected_count = 0
      wrapper.each_value do |v|
        expect(v).to eq(expected[expected_count])
        expected_count += 1
      end
      expect(expected.size).to eq(expected_count)
    end
  end

  describe "#count" do
    it "defined method" do
      expect(wrapper.respond_to?(:count)).to be_truthy
    end

    it "returns the number of keys" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expect(wrapper.count).to eq(3)
    end
  end

  describe "#size" do
    it "defined method" do
      expect(wrapper.respond_to?(:size)).to be_truthy
    end

    it "returns the number of keys" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expect(wrapper.size).to eq(3)
    end
  end

  describe "#values" do
    it "defined method" do
      expect(wrapper.respond_to?(:values)).to be_truthy
    end

    it "retuen values only as an array" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expect(wrapper.values).to eq([1, 2, 3])
    end
  end

  describe "#blank?" do
    it "defined method" do
      expect(wrapper.respond_to?(:blank?)).to be_truthy
    end

    it "returns true if it is empty" do
      expect(wrapper.blank?).to be_truthy

      wrapper.a = 1

      expect(wrapper.blank?).to be_falsey
    end
  end

  describe "#present?" do
    it "defined method" do
      expect(wrapper.respond_to?(:present?)).to be_truthy
    end

    it "returns true if it is not empty" do
      expect(wrapper.present?).to be_falsey

      wrapper.a = 1

      expect(wrapper.present?).to be_truthy
    end
  end

  describe "#dig" do
    before do
      wrapper.a.b = { c: 1, d: [1, 2, [3, 4, 5]] }
    end

    it "defined method" do
      expect(wrapper.respond_to?(:dig)).to be_truthy
    end

    it "Follow to target level" do
      expect(wrapper.dig(:a, :b, :c)).to eq(1)
    end

    it "Follow to target level" do
      expect(wrapper.dig(:a, :b, :d, 2, 0)).to eq(3)
    end

    it "Follow to target level" do
      expect(wrapper.dig(:a, :c)).to be_blank
    end
  end

  describe "#merge" do
    it "defined method" do
      expect(wrapper.respond_to?(:merge)).to be_truthy
    end

    it "merge for my class" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5
      other       = wrapper.class.new
      other.a     = 6
      other.b     = 7
      other.c.a   = 8

      expect(wrapper.merge(other).to_h).to eq({ a: 6, b: 7, c: { a: 8 } })
      expect(wrapper.to_h).to              eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 } })
    end

    it "merge for hash" do
      wrapper.a     = 1
      wrapper.b     = 2
      wrapper.c.a   = 3
      wrapper.c.b   = 4
      wrapper.c.c   = 5
      other         = {}
      other[:a]     = 6
      other[:b]     = 7
      other[:c]     = {}
      other[:c][:a] = 8

      expect(wrapper.merge(other).to_h).to eq({ a: 6, b: 7, c: { a: 8 } })
      expect(wrapper.to_h).to              eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 } })
    end
  end

  describe "#merge!" do
    it "defined method" do
      expect(wrapper.respond_to?(:merge!)).to be_truthy
    end

    it "merge for my class and save" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5
      other       = wrapper.class.new
      other.a     = 6
      other.b     = 7
      other.c.a   = 8

      expect(wrapper.merge!(other).to_h).to eq({ a: 6, b: 7, c: { a: 8 } })
      expect(wrapper.to_h).to               eq({ a: 6, b: 7, c: { a: 8 } })
    end

    it "merge for hash and save" do
      wrapper.a     = 1
      wrapper.b     = 2
      wrapper.c.a   = 3
      wrapper.c.b   = 4
      wrapper.c.c   = 5
      other         = {}
      other[:a]     = 6
      other[:b]     = 7
      other[:c]     = {}
      other[:c][:a] = 8

      expect(wrapper.merge!(other).to_h).to eq({ a: 6, b: 7, c: { a: 8 } })
      expect(wrapper.to_h).to               eq({ a: 6, b: 7, c: { a: 8 } })
    end
  end

  describe "#update" do
    it "defined method" do
      expect(wrapper.respond_to?(:update)).to be_truthy
    end

    it "update for my class and save" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5
      other       = wrapper.class.new
      other.a     = 6
      other.b     = 7
      other.c.a   = 8

      expect(wrapper.update(other).to_h).to eq({ a: 6, b: 7, c: { a: 8 } })
      expect(wrapper.to_h).to               eq({ a: 6, b: 7, c: { a: 8 } })
    end

    it "update for hash and save" do
      wrapper.a     = 1
      wrapper.b     = 2
      wrapper.c.a   = 3
      wrapper.c.b   = 4
      wrapper.c.c   = 5
      other         = {}
      other[:a]     = 6
      other[:b]     = 7
      other[:c]     = {}
      other[:c][:a] = 8

      expect(wrapper.update(other).to_h).to eq({ a: 6, b: 7, c: { a: 8 } })
      expect(wrapper.to_h).to               eq({ a: 6, b: 7, c: { a: 8 } })
    end
  end

  describe "#deep_merge" do
    it "defined method" do
      expect(wrapper.respond_to?(:deep_merge)).to be_truthy
    end

    it "Multi-tier merge for my class" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5
      other       = wrapper.class.new
      other.a     = 6
      other.b     = 7
      other.c.a   = 8

      expect(wrapper.deep_merge(other).to_h).to eq({ a: 6, b: 7, c: { a: 8, b: 4, c: 5 } })
      expect(wrapper.to_h).to                   eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 } })
    end

    it "Multi-tier merge for hash" do
      wrapper.a     = 1
      wrapper.b     = 2
      wrapper.c.a   = 3
      wrapper.c.b   = 4
      wrapper.c.c   = 5
      other         = {}
      other[:a]     = 6
      other[:b]     = 7
      other[:c]     = {}
      other[:c][:a] = 8

      expect(wrapper.deep_merge(other).to_h).to eq({ a: 6, b: 7, c: { a: 8, b: 4, c: 5 } })
      expect(wrapper.to_h).to                   eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 } })
    end
  end

  describe "#deep_merge!" do
    it "defined method" do
      expect(wrapper.respond_to?(:deep_merge!)).to be_truthy
    end

    it "Multi-tier merge for my class and save" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5
      other       = wrapper.class.new
      other.a     = 6
      other.b     = 7
      other.c.a   = 8

      expect(wrapper.deep_merge!(other).to_h).to eq({ a: 6, b: 7, c: { a: 8, b: 4, c: 5 } })
      expect(wrapper.to_h).to                    eq({ a: 6, b: 7, c: { a: 8, b: 4, c: 5 } })
    end

    it "Multi-tier merge for hash and save" do
      wrapper.a     = 1
      wrapper.b     = 2
      wrapper.c.a   = 3
      wrapper.c.b   = 4
      wrapper.c.c   = 5
      other         = {}
      other[:a]     = 6
      other[:b]     = 7
      other[:c]     = {}
      other[:c][:a] = 8

      expect(wrapper.deep_merge!(other).to_h).to eq({ a: 6, b: 7, c: { a: 8, b: 4, c: 5 } })
      expect(wrapper.to_h).to                    eq({ a: 6, b: 7, c: { a: 8, b: 4, c: 5 } })
    end
  end

  describe "#reverse_merge" do
    it "defined method" do
      expect(wrapper.respond_to?(:reverse_merge)).to be_truthy
    end

    it "Reverse merge for my class" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5
      other       = wrapper.class.new
      other.a     = 6
      other.b     = 7
      other.c.a   = 8
      other.d.a   = 9

      expect(wrapper.reverse_merge(other).to_h).to eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 }, d: { a: 9 } })
      expect(wrapper.to_h).to                      eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 } })
    end

    it "Reverse merge for hash" do
      wrapper.a     = 1
      wrapper.b     = 2
      wrapper.c.a   = 3
      wrapper.c.b   = 4
      wrapper.c.c   = 5
      other         = {}
      other[:a]     = 6
      other[:b]     = 7
      other[:c]     = {}
      other[:c][:a] = 8
      other[:d]     = {}
      other[:d][:a] = 9

      expect(wrapper.reverse_merge(other).to_h).to eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 }, d: { a: 9 } })
      expect(wrapper.to_h).to                      eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 } })
    end
  end

  describe "#reverse_merge!" do
    it "defined method" do
      expect(wrapper.respond_to?(:reverse_merge!)).to be_truthy
    end

    it "Reverse merge for my class and save" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5
      other       = wrapper.class.new
      other.a     = 6
      other.b     = 7
      other.c.a   = 8
      other.d.a   = 9

      expect(wrapper.reverse_merge!(other).to_h).to eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 }, d: { a: 9 } })
      expect(wrapper.to_h).to                       eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 }, d: { a: 9 } })
    end

    it "Reverse merge for hash and save" do
      wrapper.a     = 1
      wrapper.b     = 2
      wrapper.c.a   = 3
      wrapper.c.b   = 4
      wrapper.c.c   = 5
      other         = {}
      other[:a]     = 6
      other[:b]     = 7
      other[:c]     = {}
      other[:c][:a] = 8
      other[:d]     = {}
      other[:d][:a] = 9

      expect(wrapper.reverse_merge!(other).to_h).to eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 }, d: { a: 9 } })
      expect(wrapper.to_h).to                       eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 }, d: { a: 9 } })
    end
  end

  describe "#reverse_deep_merge" do
    it "defined method" do
      expect(wrapper.respond_to?(:reverse_deep_merge)).to be_truthy
    end

    it "Multi-tier reverse merge for my class" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5
      other       = wrapper.class.new
      other.a     = 6
      other.b     = 7
      other.c.a   = 8
      other.c.d   = 9

      expect(wrapper.reverse_deep_merge(other).to_h).to eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5, d: 9 } })
      expect(wrapper.to_h).to                           eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 } })
    end

    it "Multi-tier reverse merge for hash" do
      wrapper.a     = 1
      wrapper.b     = 2
      wrapper.c.a   = 3
      wrapper.c.b   = 4
      wrapper.c.c   = 5
      other         = {}
      other[:a]     = 6
      other[:b]     = 7
      other[:c]     = {}
      other[:c][:a] = 8
      other[:c][:d] = 9

      expect(wrapper.reverse_deep_merge(other).to_h).to eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5, d: 9 } })
      expect(wrapper.to_h).to                           eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5 } })
    end
  end

  describe "#reverse_deep_merge!" do
    it "defined method" do
      expect(wrapper.respond_to?(:reverse_deep_merge!)).to be_truthy
    end

    it "Multi-tier reverse merge for my class and save" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5
      other       = wrapper.class.new
      other.a     = 6
      other.b     = 7
      other.c.a   = 8
      other.c.d   = 9

      expect(wrapper.reverse_deep_merge!(other).to_h).to eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5, d: 9 } })
      expect(wrapper.to_h).to                            eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5, d: 9 } })
    end

    it "Multi-tier reverse merge for hash and save" do
      wrapper.a     = 1
      wrapper.b     = 2
      wrapper.c.a   = 3
      wrapper.c.b   = 4
      wrapper.c.c   = 5
      other         = {}
      other[:a]     = 6
      other[:b]     = 7
      other[:c]     = {}
      other[:c][:a] = 8
      other[:c][:d] = 9

      expect(wrapper.reverse_deep_merge!(other).to_h).to eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5, d: 9 } })
      expect(wrapper.to_h).to                            eq({ a: 1, b: 2, c: { a: 3, b: 4, c: 5, d: 9 } })
    end
  end

  describe "#fetch" do
    it "defined method" do
      expect(wrapper.respond_to?(:fetch)).to be_truthy
    end

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

  describe "#default" do
    it "defined method" do
      expect(wrapper.respond_to?(:default)).to be_truthy
    end

    it "getting default value" do
      wrapper.a.default = 0
      wrapper.b.default = []
      expect(wrapper.a.a).to eq(0)
      expect(wrapper.b.a).to eq([])
    end
  end

  describe "#default=" do
    it "defined method" do
      expect(wrapper.respond_to?(:default=)).to be_truthy
    end

    it "setting default value" do
      wrapper.a.default = []
      wrapper.a.a      << 1
      wrapper.a.b      << 2
      wrapper.a.b      << 3

      wrapper.b.default = 0
      wrapper.b.a      += 1
      wrapper.b.b      += 2
      wrapper.b.b      += 3

      expect(wrapper.a.a).to eq([1])
      expect(wrapper.a.b).to eq([2, 3])
      expect(wrapper.b.a).to eq(1)
      expect(wrapper.b.b).to eq(5)
    end
  end

  describe "#map" do
    it "defined method" do
      expect(wrapper.respond_to?(:map)).to be_truthy
    end

    it "returns the array" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3

      result = wrapper.map do |k, v|
        [k, v.respond_to?(:to_h) ? v.to_h : v]
      end

      expected = described_class::Wrapper.new(a: 3)
      expect(result).to eq([[:a, 1], [:b, 2], [:c, expected.to_h]])
    end
  end

  describe "#collect" do
    it "defined method" do
      expect(wrapper.respond_to?(:collect)).to be_truthy
    end

    it "returns the array" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3

      result = wrapper.collect do |k, v|
        [k, v.respond_to?(:to_h) ? v.to_h : v]
      end

      expected = described_class::Wrapper.new(a: 3)
      expect(result).to eq([[:a, 1], [:b, 2], [:c, expected.to_h]])
    end
  end

  describe "#map_key" do
    it "defined method" do
      expect(wrapper.respond_to?(:map_key)).to be_truthy
    end

    it "Return result of key as array" do
      expected  = [1, 2, 3]
      wrapper.a = expected[0]
      wrapper.b = expected[1]
      wrapper.c = expected[2]

      result = wrapper.map_key do |k|
        [k]
      end

      expect(result).to eq([[:a], [:b], [:c]])
    end
  end

  describe "#map_value" do
    it "defined method" do
      expect(wrapper.respond_to?(:map_value)).to be_truthy
    end

    it "Return result of value as array" do
      expected  = [1, 2, 3]
      wrapper.a = expected[0]
      wrapper.b = expected[1]
      wrapper.c = expected[2]

      result = wrapper.map_value do |k|
        [k]
      end

      expect(result).to eq([[1], [2], [3]])
    end
  end

  describe "#fetch_values" do
    it "defined method" do
      expect(wrapper.respond_to?(:fetch_values)).to be_truthy
    end

    it "Returns the value of the specified key as an array" do
      wrapper.a = 1
      wrapper.b = 2

      expect(wrapper.fetch_values(:a, :b)).to eq([1, 2])
      expect{wrapper.fetch_values(:a, :c)}.to raise_error(KeyError, "key not found: :c")
      expect(
        wrapper.fetch_values(:a, :c) do |k|
          k.upcase
        end
      ).to eq([1, :C])
    end
  end

  describe "#values_at" do
    it "defined method" do
      expect(wrapper.respond_to?(:values_at)).to be_truthy
    end

    it "Returns the value of the specified key as an array" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expect(wrapper.values_at(:a, :b, :d)).to eq([1, 2, nil])
    end
  end

  describe "#invert" do
    it "defined method" do
      expect(wrapper.respond_to?(:invert)).to be_truthy
    end

    it "Swap keys and values" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3

      expected = wrapper.each_with_object({}) do |(k, v), h|
        h[v] = k
      end

      expect(wrapper.invert).to eq(expected)
    end
  end

  describe "#delete" do
    it "defined method" do
      expect(wrapper.respond_to?(:delete)).to be_truthy
    end

    it "Delete key" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expected = wrapper.dup
      expected.keys.delete(:a)

      expect(wrapper.delete(:a)).to eq(1)
      expect(wrapper.keys).to       eq([:b, :c])
    end
  end

  describe "#delete_if" do
    it "defined method" do
      expect(wrapper.respond_to?(:delete_if)).to be_truthy
    end

    it "Delete key" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expected = wrapper.dup
      expected.delete(:a)
      expected.delete(:b)

      result = wrapper.delete_if{ |k, v| k == :a || v == 2 }
      expect(result.class).to eq(wrapper.class)
      expect(result.to_h).to  eq(expected.to_h)
      expect(wrapper.to_h).to eq(expected.to_h)
    end
  end

  describe "#find" do
    it "defined method" do
      expect(wrapper.respond_to?(:find)).to be_truthy
    end

    it "Select one key" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      result = wrapper.find do |k, v|
        k == :b || v >= 3
      end

      expected = wrapper.class.new
      expected.b = 2

      expect(result.class).to eq(expected.class)
      expect(result.to_h).to  eq(expected.to_h)
    end
  end

  describe "#select" do
    it "defined method" do
      expect(wrapper.respond_to?(:select)).to be_truthy
    end

    it "Select multiple keys" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      result = wrapper.select do |k, v|
        k == :b || v >= 3
      end

      expected = wrapper.class.new
      expected.b = 2
      expected.c = 3

      expect(result.class).to eq(expected.class)
      expect(result.to_h).to  eq(expected.to_h)
    end
  end

  describe "#find_all" do
    it "defined method" do
      expect(wrapper.respond_to?(:find_all)).to be_truthy
    end

    it "Select multiple keys" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      result = wrapper.find_all do |k, v|
        k == :b || v >= 3
      end

      expected = wrapper.class.new
      expected.b = 2
      expected.c = 3

      expect(result.class).to eq(expected.class)
      expect(result.to_h).to  eq(expected.to_h)
    end
  end

  describe "#reject" do
    it "defined method" do
      expect(wrapper.respond_to?(:reject)).to be_truthy
    end

    it "Excludes specified key" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      result = wrapper.reject do |k, v|
        v > 2
      end

      expected = wrapper.class.new
      expected.a = 1
      expected.b = 2

      expect(result.class).to eq(expected.class)
      expect(result.to_h).to  eq(expected.to_h)
    end
  end

  describe "#reject!" do
    it "defined method" do
      expect(wrapper.respond_to?(:reject!)).to be_truthy
    end

    it "Excludes specified key and save" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      wrapper.reject! do |k, v|
        v > 2
      end

      expect(wrapper.to_h).to eq({ a: 1, b: 2 })
    end
  end

  describe "#inject" do
    it "defined method" do
      expect(wrapper.respond_to?(:inject)).to be_truthy
    end

    it "Edit with the specified type" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      result = wrapper.inject do |sum, (_k, v)|
        sum + v
      end

      result2 = wrapper.inject([]) do |arr, (k, v)|
        arr << k if v > 2
      end

      expect(result).to  eq(6)
      expect(result2).to eq([:c])
    end
  end

  describe "#reduce" do
    it "defined method" do
      expect(wrapper.respond_to?(:reduce)).to be_truthy
    end

    it "Edit with the specified type" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      result = wrapper.reduce do |sum, (_k, v)|
        sum + v
      end

      result2 = wrapper.reduce([]) do |arr, (k, v)|
        arr << k if v > 2
      end

      expect(result).to  eq(6)
      expect(result2).to eq([:c])
    end
  end

  describe "#clear" do
    it "defined method" do
      expect(wrapper.respond_to?(:clear)).to be_truthy
    end

    it "clear setting keys" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3
      wrapper.clear
      expect(wrapper.to_h).to eq({})
    end
  end

  describe "#replace" do
    it "defined method" do
      expect(wrapper.respond_to?(:replace)).to be_truthy
    end

    it "Swap values in my class" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3
      other     = wrapper.class.new
      other.c   = 1
      other.d   = 2
      other.e   = 3

      wrapper.replace other

      expect(wrapper.to_h).to eq(other.to_h)
    end

    it "Swap values in hash" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3
      other     = {}
      other[:c] = 1
      other[:d] = 2
      other[:e] = 3

      wrapper.replace other

      expect(wrapper.to_h).to eq(other.to_h)
    end
  end

  describe "#flatten" do
    it "defined method" do
      expect(wrapper.respond_to?(:flatten)).to be_truthy
    end

    it "Flatten and return as array" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5

      expect(wrapper.flatten).to eq([:a, 1, :b, 2, :c, { a: 3, b: 4, c: 5}])
    end
  end

  describe "#has_key?" do
    it "defined method" do
      expect(wrapper.respond_to?(:has_key?)).to be_truthy
    end

    it "Returns true if there is a corresponding key" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expect(wrapper.has_key?(:a)).to be_truthy
      expect(wrapper.has_key?(:d)).to be_falsey
    end
  end

  describe "#include?" do
    it "defined method" do
      expect(wrapper.respond_to?(:include?)).to be_truthy
    end

    it "Returns true if corresponding key is included" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expect(wrapper.include?(:a)).to be_truthy
      expect(wrapper.include?(:d)).to be_falsey
    end
  end

  describe "#has_keys?" do
    it "defined method" do
      expect(wrapper.respond_to?(:has_keys?)).to be_truthy
    end

    it "Returns true if corresponding key is included" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3

      expect(wrapper.has_keys?(:a)).to     be_truthy
      expect(wrapper.has_keys?(:c, :a)).to be_truthy
      expect(wrapper.has_keys?(:d)).to     be_falsey
      expect(wrapper.has_keys?(:c, :b)).to be_falsey
      expect(wrapper.has_keys?(:d, :a)).to be_falsey
    end
  end

  describe "#exclude?" do
    it "defined method" do
      expect(wrapper.respond_to?(:exclude?)).to be_truthy
    end

    it "Returns true if the corresponding key is not included" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expect(wrapper.exclude?(:a)).to be_falsey
      expect(wrapper.exclude?(:d)).to be_truthy
    end
  end

  describe "#sort" do
    it "defined method" do
      expect(wrapper.respond_to?(:sort)).to be_truthy
    end

    it "Sort and return as array" do
      wrapper.c = 1
      wrapper.b = 2
      wrapper.a = 3

      expect(wrapper.sort).to eq([[:a, 3], [:b, 2], [:c, 1]])
    end
  end

  describe "#shift" do
    it "defined method" do
      expect(wrapper.respond_to?(:shift)).to be_truthy
    end

    it "Retrieve the initial key value" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expect(wrapper.shift).to eq([:a, 1])
      expect(wrapper.to_h).to  eq({ b: 2, c: 3})
    end
  end

  describe "#to_a" do
    it "defined method" do
      expect(wrapper.respond_to?(:to_a)).to be_truthy
    end

    it "Convert to an array" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5

      expect(wrapper.to_a).to eq([[:a, 1], [:b, 2], [:c, { a: 3, b: 4, c: 5}]])
    end
  end

  describe "#to_ary" do
    it "defined method" do
      expect(wrapper.respond_to?(:to_ary)).to be_truthy
    end

    it "Convert to an array" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3
      wrapper.c.b = 4
      wrapper.c.c = 5

      expect(wrapper.to_ary).to eq([[:a, 1], [:b, 2], [:c, { a: 3, b: 4, c: 5}]])
    end
  end

  describe "#compact" do
    it "defined method" do
      expect(wrapper.respond_to?(:compact)).to be_truthy
    end

    it "Delete empty key" do
      wrapper.a   = 1
      wrapper.b   = nil
      wrapper.c.a = 2
      wrapper.c.b
      wrapper.c.c = ""

      expect(wrapper.keys).to           eq([:a, :b, :c])
      expect(wrapper.c.keys).to         eq([:a, :b, :c])
      expect(wrapper.compact.keys).to   eq([:a, :c])
      expect(wrapper.compact.c.keys).to eq([:a, :b, :c])
      expect(wrapper.keys).to           eq([:a, :b, :c])
      expect(wrapper.c.keys).to         eq([:a, :b, :c])
    end
  end

  describe "#compact!" do
    it "defined method" do
      expect(wrapper.respond_to?(:compact!)).to be_truthy
    end

    it "Delete empty key and save" do
      wrapper.a   = 1
      wrapper.b   = nil
      wrapper.c.a = 2
      wrapper.c.b
      wrapper.c.c = ""

      expect(wrapper.keys).to            eq([:a, :b, :c])
      expect(wrapper.c.keys).to          eq([:a, :b, :c])
      expect(wrapper.compact!.keys).to   eq([:a, :c])
      expect(wrapper.compact!.c.keys).to eq([:a, :b, :c])
      expect(wrapper.keys).to            eq([:a, :c])
      expect(wrapper.c.keys).to          eq([:a, :b, :c])
    end
  end

  describe "#deep_compact" do
    it "defined method" do
      expect(wrapper.respond_to?(:deep_compact)).to be_truthy
    end

    it "Delete empty deep key" do
      wrapper.a   = 1
      wrapper.b   = nil
      wrapper.c.a = 2
      wrapper.c.b
      wrapper.c.c = ""

      expect(wrapper.keys).to                eq([:a, :b, :c])
      expect(wrapper.c.keys).to              eq([:a, :b, :c])
      expect(wrapper.deep_compact.keys).to   eq([:a, :c])
      expect(wrapper.deep_compact.c.keys).to eq([:a, :c])
      expect(wrapper.keys).to                eq([:a, :b, :c])
      expect(wrapper.c.keys).to              eq([:a, :b, :c])
    end
  end

  describe "#deep_compact!" do
    it "defined method" do
      expect(wrapper.respond_to?(:deep_compact!)).to be_truthy
    end

    it "Delete empty deep key and save" do
      wrapper.a   = 1
      wrapper.b   = nil
      wrapper.c.a = 2
      wrapper.c.b
      wrapper.c.c = ""

      expect(wrapper.keys).to                 eq([:a, :b, :c])
      expect(wrapper.c.keys).to               eq([:a, :b, :c])
      expect(wrapper.deep_compact!.keys).to   eq([:a, :c])
      expect(wrapper.deep_compact!.c.keys).to eq([:a, :c])
      expect(wrapper.keys).to                 eq([:a, :c])
      expect(wrapper.c.keys).to               eq([:a, :c])
    end
  end

  describe "#slice" do
    it "defined method" do
      expect(wrapper.respond_to?(:slice)).to be_truthy
    end

    it "Retrieve with a specific key" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expect(wrapper.slice(:a, :b).to_h).to eq({ a: 1, b: 2 })
      expect(wrapper.slice(:b, :c).to_h).to eq({ b: 2, c: 3 })
      expect(wrapper.slice(:c, :d).to_h).to eq({ c: 3 })
      expect(wrapper.to_h).to               eq({ a: 1, b: 2, c: 3 })
    end
  end

  describe "#slice!" do
    it "defined method" do
      expect(wrapper.respond_to?(:slice!)).to be_truthy
    end

    it "Retrieve with a specific key and save" do
      wrapper.a = 1
      wrapper.b = 2
      wrapper.c = 3

      expect(wrapper.slice!(:a, :b).to_h).to eq({ a: 1, b: 2 })
      expect(wrapper.to_h).to                eq({ a: 1, b: 2 })
    end
  end

  describe "#to_hash" do
    it "defined method" do
      expect(wrapper.respond_to?(:to_hash)).to be_truthy
    end

    it "Convert to hash" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3

      expect(wrapper.to_hash).to eq({ a: 1, b: 2, c: { a: 3 } })
    end
  end

  describe "#to_h" do
    it "defined method" do
      expect(wrapper.respond_to?(:to_h)).to be_truthy
    end

    it "Convert to hash" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3

      expect(wrapper.to_h).to eq({ a: 1, b: 2, c: { a: 3 } })
    end
  end

  describe "#to_json" do
    it "defined method" do
      expect(wrapper.respond_to?(:to_h)).to be_truthy
    end

    it "Convert to json" do
      wrapper.a   = 1
      wrapper.b   = 2
      wrapper.c.a = 3

      expect(wrapper.to_json).to eq({ a: 1, b: 2, c: { a: 3 } }.to_json)
    end
  end
end
