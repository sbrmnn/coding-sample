module Response
  extend ActiveSupport::Concern
  
  protected

  def json_response(record, status)
    status = :not_found if record.blank?
    case status
      when :unprocessable_entity
        object = record.errors
      when :not_found
        object = record || "not_found"
      else
        object = record
    end
    render json: object, status: status
  end
end