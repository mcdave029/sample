class SampleController < ApplicationController
  def new
  end

  def create
    handler = SampleHandler.new(data: params[:data], size: params[:size].to_i, limit: params[:limit].to_i).make

    respond_to do |format|
      format.html { send_data csv_of(data: handler), filename: "sample-#{Date.today}.csv" }
    end
  end

  private

  def csv_of(data:)
    attributes = [nil, "No.", "Names", "LRN", "Student Type", "Track & Strand",  "Billing Statement", "Voucher Amout", "Grade Level"]

    CSV.generate(headers: true) do |csv|
      csv << ["School: #{data.filename}"]
      csv << ["Population: #{data.original_data.last[0]}"]
      csv << ["Sample Size: #{data.size}"]
      csv << ["Interval: #{data.interval}"]
      csv << ["RNS: #{data.rns}"]
      csv << []

      csv << attributes

      data.sample.each_with_index do |d,i|
        csv << d.unshift(i + 1)
      end
    end
  end
end
