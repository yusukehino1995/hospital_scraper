# frozen_string_literal: true

class HospitalsController < ApplicationController

  BASE_URL = "https://byoinnavi.jp"

  def index
    respond_to do |format|
      format.html
      format.csv do
        export_csv(params[:target_path])
      end
  rescue StandardError => e
    Rails.logger.error(e)
    end
  end

  private

  def export_csv(target_path)
    hospital_data = read_data(target_path)
    send_data(create_csv(hospital_data), filename: '病院ナビ.csv', type: :csv)
  end

  def read_data(target_path)
    data = []
    loop do
      url = BASE_URL + target_path
      doc = Nokogiri::HTML.parse(open(url))
      doc.css('.corp_table').css('.corp.corp_type_clinic').each do |element|
        name = element.search('.corp_name a').text
        phone_number = element.search('.clinic_tel').text.gsub(/(\r\n|\n|-)/, '')
        address = element.search('.clinic_address').children.first.text.gsub(/(\r\n|\n)/, '')
        hospital_url = element.search('.clinic_url a').attr('href')&.value
        data << { name: name, phone_number: phone_number, address: address, hospital_url: hospital_url }
      end
      target_path = doc.search('.pagination_next').attr('href')&.value
      break unless target_path
    end
    data
  end

  def create_csv(hospital_data)
    bom = "\uFEFF"
    CSV.generate(bom) do |csv|
      column_names = %w[病院名 電話番号 住所 病院のサイトURL]
      csv << column_names
      hospital_data.each do |d|
        csv << [
          d[:name], 
          d[:phone_number],
          d[:address],
          d[:hospital_url]
        ]
      end
    end
  end
end
