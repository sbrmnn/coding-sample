class AwsLambdaService
  
  def initialize(function_name, payload=nil, region=nil, access_key_id=nil, secret_access_key=nil)
    @function_name = function_name
    @region = region
    @access_key_id = access_key_id
    @secret_access_key = secret_access_key
    @payload = payload
  end

  def response
    resp_payload = JSON.parse(call.payload.string)   
  end

  private

  def call
    lambda_object.invoke(arguments)
  end

  def arguments
    @arguments ||= {
      function_name: @function_name,
      payload: JSON.generate(@payload),
      invocation_type: "RequestResponse"
    }.compact
  end

  def lambda_object
    @lambda_object ||= Aws::Lambda::Client.new(lambda_creds)
  end

  def lambda_creds
    @creds ||= {
      region: @region,
      access_key_id: @access_key_id,
      secret_access_key: @secret_access_key
    }.compact
  end
end


