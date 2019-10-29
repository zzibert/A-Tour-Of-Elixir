defmodule BmwUmbrella.ClientApi do
  @api_key Application.get_env(:bmw_umbrella, :api_key)

  @otpclearance_base_url "https://api.bmwgroup.com/otpclearance/api/thirdparty/v1/test/applications/containers/"
  @otpdatadelivery_base_url "https://api.bmwgroup.com/otpdatadelivery/api/thirdparty/v1/test/clearances/"
  @otpcapability_base_url "https://api.bmwgroup.com/otpcapability/api/thirdparty/v1/test/getCapabilities"

  @test_clearance_id "11111111-1111-1111-1111-111111111111"
  @headers [KeyId: @api_key, "Content-Type": "application/json"]

  def request_data_access_clearance(vin, container_id) do
    (@otpclearance_base_url <> container_id <> "/vehicles/" <> vin <> "/clearances")
    |> post("", @headers)
  end

  def access_to_telematics_data(clearance_id) do
    (@otpdatadelivery_base_url <> clearance_id <> "/telematicdata")
    |> get(@headers)
  end

  def access_to_telematics_data_with_request_id(clearance_id, request_id) do
    (@otpdatadelivery_base_url <> clearance_id <> "/telematicdata/" <> request_id)
    |> get(@headers)
  end

  def check_if_vehicle_is_bmw_cardata_capable(vin) do
    body = Poison.encode!(%{vin: vin})

    post(@otpcapability_base_url, body, @headers)
  end

  def check_if_vehicle_is_bmw_cardata_capable_and_availability_types_of_keys(vin, container_id) do
    body = Poison.encode!(%{vin: vin, containerId: container_id})

    post(@otpcapability_base_url, body, @headers)
  end

  defp request(method, url, headers, body \\ "") do
    case HTTPoison.request(method, url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code >= 200 and code < 300 ->
        Poison.decode(body)

      {:ok, %HTTPoison.Response{body: body, status_code: code}} ->
        {:error, body, code}

      {:error, _} = response ->
        response
    end
  end

  defp get(url, headers), do: request(:get, url, headers)

  defp post(url, body, headers), do: request(:post, url, headers, body)
end
