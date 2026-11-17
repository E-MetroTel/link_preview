defmodule LinkPreview.Requests do
  @moduledoc """
    Module providing functions to handle needed requests.
  """
  alias LinkPreview.Processor

  def get(url, opts \\ []), do: Tesla.get(client(), url, opts)
  def head(url, opts \\ []), do: Tesla.head(client(), url, opts)

  defp client do
    adapter =
      :tesla
      |> Application.get_env(__MODULE__, [])
      |> Keyword.get(:adapter, {Tesla.Adapter.Httpc, body_format: :binary})

    Tesla.client(
      [
        {Tesla.Middleware.BaseUrl, "http://"},
        {Tesla.Middleware.DecompressResponse, max_body_size: 32 * 1024 * 1024},
        Tesla.Middleware.FollowRedirects
      ],
      adapter
    )
  end

  @doc """
    Check if given url leads to image.
  """
  @spec image?(String.t()) :: boolean
  def image?(url) do
    case head(url) do
      {:ok, %Tesla.Env{status: 200, headers: _headers} = env} ->
        Processor.content_type?(env, ~r/\Aimage\//)

      {:ok, %Tesla.Env{}} ->
        false

      {:error, _reason} ->
        false
    end
  end
end
