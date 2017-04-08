require 'net/http'
require 'uri'
require 'json'

module Transferable
  extend ActiveSupport::Concern

  def send_to_wrapper(user_id, max_transfer_amount, origin_account, destination_account, financial_institution_id)
    uri = URI.parse("https://wrapper.monotto.com/transfer")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = JSON.dump({
      "transfer" => {
        "user_id" => user_id,
        "max_transfer_amount" => max_transfer_amount,
        "origin_account" => origin_account,
        "destination_account" => destination_account,
        "financial_institution_id" => financial_institution_id
      }
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end
end