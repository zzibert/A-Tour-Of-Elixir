defmodule BmwUmbrella.ClientApi do
  @api_key Application.get_env(:client, :api_key)
  @base_url "https://api.bmwgroup.com/otpcapability/api/thirdparty/v1/test"
  @test_clearance_id "11111111-1111-1111-1111-111111111113"
  @headers [KeyId: @api_key, "Content-Type": "application/json"]

  def request_data_acces_clearance(vin, container_id) do
    (@base_url <>
       "/otpclearance/api/thirdparty/v1/test/applications/containers/" <>
       container_id <> "/vehicles/" <> vin <> "/clearances")
    |> post("", @headers)
  end

  def get_telematics_data(clearanceID) do
    (@base_url <>
       "/clearances/" <> clearanceID <> "/telematicdata")
    |> get(@headers)
  end

  def get_telematics_data_with_requestID(clearanceID, requestID) do
    (@base_url <>
       "/clearances/" <>
       clearanceID <> "/telematicdata/" <> requestID)
    |> get(@headers)
  end

  def get_vehicle_capability(vin) do
    body = Poison.encode!(%{vin: vin})

    (@base_url <> "/getCapabilities")
    |> post(body, @headers)
  end

  def get_container_vin_capability(vin, containerID) do
    body = Poison.encode!(%{vin: vin, containerId: containerID})

    (@base_url <> "/getCapabilities")
    |> post(body, @headers)
  end

  defp request(method, url, headers, body \\ "") do
    case HTTPoison.request(method, url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code >= 200 and code < 300 ->
        Poison.decode(body)

      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, body}

      {:error, _} = response ->
        response
    end
  end

  defp get(url, headers), do: request(:get, url, headers)

  defp post(url, body, headers), do: request(:post, url, headers, body)
end
