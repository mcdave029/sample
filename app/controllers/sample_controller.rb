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
    attributes = ["id", "Names", "LRN", "Student Type", "Track & Strand",  "Billing Statement", "Voucher Amout", "Grade Level"]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      data.sample.each do |d|
        csv << d
      end

      csv << []

      csv << ["Population: #{data.original_data.last[0]}"]
      csv << ["Sample Size: #{data.size}"]
      csv << ["Interval: #{data.interval}"]
      csv << ["RNS: #{data.rns}"]
    end
  end
end
