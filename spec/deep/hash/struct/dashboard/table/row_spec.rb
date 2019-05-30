require "rspec"

RSpec.describe Deep::Hash::Struct::Dashboard::Table::Row do
  before do
    @options = {}
  end

  let(:options) { @options }
  let(:row) { described_class.new options }

  describe "#header?" do
    context "When there is a header option" do
      before do
        options[:header] = true
      end

      it "Return true" do
        expect(row.header?).to be_truthy
      end
    end

    context "When there is no header option" do
      it "Return false" do
        expect(row.header?).to be_falsey
      end
    end
  end

  describe "#side?" do
    context "When there is a side option" do
      before do
        options[:side] = true
      end

      it "Return true" do
        expect(row.side?).to be_truthy
      end
    end

    context "When there is no side option" do
      it "Return false" do
        expect(row.side?).to be_falsey
      end
    end
  end

  describe "#side_header?" do
    context "When there is a header and side option" do
      before do
        options[:header] = true
        options[:side]   = true
      end

      it "Return true" do
        expect(row.side_header?).to be_truthy
      end
    end

    context "When there is a header option" do
      before do
        options[:header] = true
      end

      it "Return false" do
        expect(row.side_header?).to be_falsey
      end
    end

    context "When there is a side option" do
      before do
        options[:side] = true
      end

      it "Return false" do
        expect(row.side_header?).to be_falsey
      end
    end


    context "When there is no header and side option" do
      it "Return false" do
        expect(row.side_header?).to be_falsey
      end
    end
  end

  describe "#side_or_header?" do
    context "When there is a header and side option" do
      before do
        options[:header] = true
        options[:side]   = true
      end

      it "Return true" do
        expect(row.side_or_header?).to be_truthy
      end
    end

    context "When there is a header option" do
      before do
        options[:header] = true
      end

      it "Return true" do
        expect(row.side_or_header?).to be_truthy
      end
    end

    context "When there is a side option" do
      before do
        options[:side] = true
      end

      it "Return true" do
        expect(row.side_or_header?).to be_truthy
      end
    end


    context "When there is no header and side option" do
      it "Return false" do
        expect(row.side_or_header?).to be_falsey
      end
    end
  end
end
