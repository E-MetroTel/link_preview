defmodule LinkPreview.RequestsTest do
  use LinkPreview.Case
  alias LinkPreview.Requests

  test "decompresses gzip responses" do
    assert {:ok, %{status: 200, body: body}} = Requests.get(@httparrot <> "/gzip")
    assert is_map(Jason.decode!(body))
  end

  test "follows redirects" do
    assert {:ok, %{status: 200, url: url}} =
             Requests.get(@httparrot <> "/redirect-to", query: [url: "/image"])

    assert url == @httparrot <> "/image"
  end

  describe "image?/1" do
    test "when url leads to image" do
      assert Requests.image?(@httparrot <> "/image")
    end

    test "when URL returns an HTTP error" do
      refute Requests.image?(@httparrot <> "/status/404")
    end

    test "when url doesn't lead to image" do
      refute Requests.image?(@httparrot <> "/get")
    end
  end
end
