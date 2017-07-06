require "spec_helper"

describe Deep::Hash::Struct::Dashboard do
  let(:dashboard) { described_class.new }

  describe "Add table" do
    it "Add matrix table" do
      expect(dashboard.tables.size).to eq(0)

      dashboard.add_table(matrix: true) do |t|
        t.add_header do |h|
          h.a   = "header1"
          h[:b] = "header2"
          h.add :c, "header3"
        end

        t.add_side do |s|
          s.a   = "side1"
          s[:b] = "side2"
          s.add :c, "side3"
        end

        t.add_body do |row|
          row.a.a     = 1
          row.a[:b]   = 2
          row[:a][:c] = 3
          row[:b].a   = 4
          row.b.add :b, 5
          row.b.c     = 6
          row.c.a     = 7
          row.c.b     = 8
          row.c.c     = 9
        end
      end

      expect(dashboard.tables.size).to     eq(1)
      expect(dashboard.tables[0].class).to eq(Deep::Hash::Struct::Dashboard::Table)

      results = []
      dashboard.each do |d|
        d.each do |rows|
          result = []
          rows.each do |r|
            result << (r.header? || r.side? ? r.name : r.value)
          end
          results << result
        end
      end
      expect(results).to eq([
        [nil, "header1", "header2", "header3"],
        ["side1", 1, 4, 7],
        ["side2", 2, 5, 8],
        ["side3", 3, 6, 9]
      ])
    end

    it "Setting side header name" do
      expect(dashboard.tables.size).to eq(0)

      dashboard.add_table(matrix: true, side_header: "side_header") do |t|
        t.add_header do |h|
          h.a   = "header1"
          h[:b] = "header2"
          h.add :c, "header3"
        end

        t.add_side do |s|
          s.a   = "side1"
          s[:b] = "side2"
          s.add :c, "side3"
        end

        t.add_body do |row|
          row.a.a     = 1
          row.a[:b]   = 2
          row[:a][:c] = 3
          row[:b].a   = 4
          row.b.add :b, 5
          row.b.c     = 6
          row.c.a     = 7
          row.c.b     = 8
          row.c.c     = 9
        end
      end

      expect(dashboard.tables.size).to     eq(1)
      expect(dashboard.tables[0].class).to eq(Deep::Hash::Struct::Dashboard::Table)

      results = []
      dashboard.each do |d|
        d.each do |rows|
          result = []
          rows.each do |r|
            result << (r.header? || r.side? ? r.name : r.value)
          end
          results << result
        end
      end
      expect(results).to eq([
        ["side_header", "header1", "header2", "header3"],
        ["side1", 1, 4, 7],
        ["side2", 2, 5, 8],
        ["side3", 3, 6, 9]
      ])
    end

    it "Add segment table" do
      dashboard.add_table do |t|
        t.add_header do |h|
          h.a   = "header1"
          h[:b] = "header2"
          h.add :c, "header3"
        end

        t.add_body do |row|
          row.a = 1
          row.b = 2
          row.c = 3
        end

        t.add_body do |row|
          row.c = 6
          row.b = 5
          row.a = 4
        end

        t.add_body do |row|
          row.c = 9
          row.a = 7
          row.b = 8
        end
      end

      expect(dashboard.tables.size).to     eq(1)
      expect(dashboard.tables[0].class).to eq(Deep::Hash::Struct::Dashboard::Table)

      results = []
      dashboard.each do |d|
        d.each do |rows|
          result = []
          rows.each do |r|
            result << (r.header? || r.side? ? r.name : r.value)
          end
          results << result
        end
      end
      expect(results).to eq([
        ["header1", "header2", "header3"],
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ])
    end

    it "Unset value to matrix table" do
      dashboard.add_table(matrix: true) do |t|
        t.add_header do |h|
          h.a   = "header1"
          h[:b] = "header2"
          h.add :c, "header3"
        end

        t.add_side do |s|
          s.a   = "side1"
          s[:b] = "side2"
          s.add :c, "side3"
        end

        t.add_body do |row|
          row.a.b = 2
          row.a.c = 3
          row.b.a = 4
          row.b.c = 6
          row.c.a = 7
          row.c.b = 8
        end
      end

      expect(dashboard.tables.size).to     eq(1)
      expect(dashboard.tables[0].class).to eq(Deep::Hash::Struct::Dashboard::Table)

      results = []
      dashboard.each do |d|
        d.each do |rows|
          result = []
          rows.each do |r|
            result << (r.header? || r.side? ? r.name : r.value)
          end
          results << result
        end
      end
      expect(results).to eq([
        [nil, "header1", "header2", "header3"],
        ["side1", nil, 4, 7],
        ["side2", 2, nil, 8],
        ["side3", 3, 6, nil]
      ])
    end

    it "Unset value to segment table" do
      dashboard.add_table do |t|
        t.add_header do |h|
          h.a = "header1"
          h.b = "header2"
          h.c = "header3"
        end

        t.add_body do |row|
          row.b = 2
          row.c = 3
        end

        t.add_body do |row|
          row.a = 4
          row.c = 6
        end

        t.add_body do |row|
          row.a = 7
          row.b = 8
        end
      end

      expect(dashboard.tables.size).to     eq(1)
      expect(dashboard.tables[0].class).to eq(Deep::Hash::Struct::Dashboard::Table)

      results = []
      dashboard.each do |d|
        d.each do |rows|
          result = []
          rows.each do |r|
            result << (r.header? || r.side? ? r.name : r.value)
          end
          results << result
        end
      end
      expect(results).to eq([
        ["header1", "header2", "header3"],
        [nil, 2, 3],
        [4, nil, 6],
        [7, 8, nil]
      ])
    end

    it "Default to matrix table" do
      dashboard.add_table(matrix: true, default: 0) do |t|
        t.add_header do |h|
          h.a = "header1"
          h.b = "header2"
          h.c = "header3"
        end

        t.add_side do |s|
          s.a = "side1"
          s.b = "side2"
          s.c = "side3"
        end

        t.add_body do |row|
          row.a.b = 2
          row.a.c = 3
          row.b.a = 4
          row.b.c = 6
          row.c.a = 7
          row.c.b = 8
        end
      end

      expect(dashboard.tables.size).to     eq(1)
      expect(dashboard.tables[0].class).to eq(Deep::Hash::Struct::Dashboard::Table)

      results = []
      dashboard.each do |d|
        d.each do |rows|
          result = []
          rows.each do |r|
            result << (r.header? || r.side? ? r.name : r.value)
          end
          results << result
        end
      end
      expect(results).to eq([
        [nil, "header1", "header2", "header3"],
        ["side1", 0, 4, 7],
        ["side2", 2, 0, 8],
        ["side3", 3, 6, 0]
      ])
    end

    it "Default to segment table" do
      dashboard.add_table(default: 0) do |t|
        t.add_header do |h|
          h.a = "header1"
          h.b = "header2"
          h.c = "header3"
        end

        t.add_body do |row|
          row.b = 2
          row.c = 3
        end

        t.add_body do |row|
          row.a = 4
          row.c = 6
        end

        t.add_body do |row|
          row.a = 7
          row.b = 8
        end
      end

      expect(dashboard.tables.size).to     eq(1)
      expect(dashboard.tables[0].class).to eq(Deep::Hash::Struct::Dashboard::Table)

      results = []
      dashboard.each do |d|
        d.each do |rows|
          result = []
          rows.each do |r|
            result << (r.header? || r.side? ? r.name : r.value)
          end
          results << result
        end
      end
      expect(results).to eq([
        ["header1", "header2", "header3"],
        [0, 2, 3],
        [4, 0, 6],
        [7, 8, 0]
      ])
    end
  end

  describe "#add_table" do
    it "Count up table" do
      expect { dashboard.add_table }.to change { dashboard.tables.size }.by(1)
    end

    it "Count up table include block" do
      expect do
        dashboard.add_table do |t|
          t.add_header do |h|
            h.a = "header"
          end
          t.add_body do |row|
            row.a = 1
          end
        end
      end.to change { dashboard.tables.size }.by(1)
    end
  end

  describe "#each" do
    before do
      dashboard.tables = expected
    end

    let(:expected) { [1, 2, 3] }

    it "The target of each is tables" do
      index = 0
      dashboard.each do |t|
        expect(t).to eq(expected[index])
        index += 1
      end
      expect(index).to eq(expected.size)
    end

    it "Omitting the block returns the Enumerator class" do
      index = 0
      dashboard.each.with_index(1) do |t, i|
        expect(t).to eq(expected[index])
        expect(i).to eq(index + 1)
        index += 1
      end
      expect(index).to eq(expected.size)
    end
  end

  describe "#map" do
    before do
      dashboard.tables = expected
    end

    let(:expected) { [1, 2, 3] }

    it "The target of map is tables" do
      result = dashboard.map do |t|
        t.to_s
      end
      expect(result).to eq(expected.map(&:to_s))
    end

    it "Omitting the block returns the Enumerator class" do
      result = dashboard.map.each_with_index do |t, i|
        [t, i]
      end
      expect(result).to eq([[1, 0], [2, 1], [3, 2]])
    end
  end

  describe "#collect" do
    before do
      dashboard.tables = expected
    end

    let(:expected) { [1, 2, 3] }

    it "The target of collect is tables" do
      result = dashboard.collect do |t|
        t.to_s
      end
      expect(result).to eq(expected.map(&:to_s))
    end

    it "Omitting the block returns the Enumerator class" do
      result = dashboard.collect.each_with_index do |t, i|
        [t, i]
      end
      expect(result).to eq([[1, 0], [2, 1], [3, 2]])
    end
  end
end
