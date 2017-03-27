module Response
  extend ActiveSupport::Concern
  
  protected

  def json_response(record, status)
    (render json: "null", status: :not_found and return) if (record.blank? || status == :not_found) 
    case status
      when :unprocessable_entity
        object = record.errors
      else
        object = record
    end
    render json: object, status: status
  end
end