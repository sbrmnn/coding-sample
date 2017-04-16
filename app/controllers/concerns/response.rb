module Response
  extend ActiveSupport::Concern
  
  protected

  def render_unauthorized(message)
    errors = { errors: [ { detail: message } ] }
    render json: errors, status: :unauthorized
  end

  def json_response(record, status)
    status = :not_found if record.nil?
    case status
      when :unprocessable_entity
        object = record.errors
      when :not_found
        object = "not_found"
      else
        status = :ok
        object = record
    end
    render json: object, status: status
  end
end