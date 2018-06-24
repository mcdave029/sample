# Sampling method for surveys
class SampleHandler
  attr_accessor :filename, :original_data, :size, :limit, :sample, :rns, :interval

  def initialize(data:, size:, limit:)
    r_data = Roo::Spreadsheet.open(data.path).sheet(0)
    @filename = File.basename(data.original_filename, ".*")
    @original_data = r_data.each_with_index.map { |d, i| d if i > 0 }.compact
    @data = r_data.each_with_index.map { |d, i| d if i > 0 }.compact
    @size = size
    @limit = limit
    @sample = []
    @rns = rand(1..@data.count)
    @interval = @data.count / size
  end

  def make
    @dindex = rns

    initialize_first_group

    @dindex -= @data.count

    delete_from_data

    push_items

    self
  end

  private

  def initialize_first_group
    @data.each_with_index do |d, i|
      i += 1
      if rns == i || (i >= rns && i == @dindex)
        sample << d
        @dindex += interval
      end
    end
  end

  def push_items
    @data.each_with_index do |d, i|
      break if sample_reached
      i += 1
      if i == @dindex
        sample << d
        @dindex += interval
      end
    end
    return if sample_reached
    @dindex -= @data.count
    delete_from_data
    push_items
  end

  def delete_from_data
    sample.each do |d|
      @data.delete(d)
    end
  end

  def sample_reached
    sample.count == limit
  end
end
