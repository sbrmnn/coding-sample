module Response
  extend ActiveSupport::Concern
  
  protected

  def json_response(record, status = :ok)
    case status
      when :unprocessable_entity
        object = record.errors
      when :not_found
        object = { error: exception.message }
      else
         object = record
    end
    render json: object, status: status
  end
end