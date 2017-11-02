module Response
  extend ActiveSupport::Concern
  
  protected

  def render_unauthorized(message)
    errors = { errors: [ { detail: message } ] }
    render json: errors, status: :unauthorized
  end

  def json_response(record)
    if record.blank?
      object = {}
      status = :not_found
    elsif record.try(:errors).present?
      object = record.errors
      status = :unprocessable_entity
    else
      status = :ok
      object = record  
    end
    render json: object, status: status
  end
end