defmodule LinkPreview.ProcessorTest do
  use LinkPreview.Case
  alias LinkPreview.Parsers.{Opengraph, Html}

  import Mox

  setup :verify_on_exit!

  setup do
    previous = Application.get_env(:tesla, LinkPreview.Requests)
    Application.put_env(:tesla, LinkPreview.Requests, adapter: LinkPreview.TestAdapter)
    previous_parsers = Application.fetch_env(:link_preview, :parsers)

    on_exit(fn ->
      if previous do
        Application.put_env(:tesla, LinkPreview.Requests, previous)
      else
        Application.delete_env(:tesla, LinkPreview.Requests)
      end

      case previous_parsers do
        {:ok, value} -> Application.put_env(:link_preview, :parsers, value)
        :error -> Application.delete_env(:link_preview, :parsers)
      end
    end)

    :ok
  end

  test "ignores missing parsers and returns parsed HTML" do
    expect(LinkPreview.TestAdapter, :call, fn %{method: :head} = env, _ ->
      {:ok, %{env | status: 200, headers: [{"content-type", "text/html"}]}}
    end)

    expect(LinkPreview.TestAdapter, :call, fn %{method: :get} = env, _ ->
      {:ok, %{env | status: 200, body: @opengraph}}
    end)

    Application.put_env(:link_preview, :parsers, [Opengraph, Html, MissingOne])

    assert {:ok, %LinkPreview.Page{title: "Opengraph Test Title"}} =
             LinkPreview.Processor.call(@httparrot <> "/page")
  end

  test "image checks return false on transport errors" do
    expect(LinkPreview.TestAdapter, :call, fn %{method: :head}, _ -> {:error, :timeout} end)
    refute LinkPreview.Requests.image?(@httparrot <> "/image")
  end

  test "returns errors for non-success HTTP statuses" do
    expect(LinkPreview.TestAdapter, :call, fn env, _ -> {:ok, %{env | status: 404}} end)

    assert {:error, %LinkPreview.Error{message: "unsupported response"}} =
             LinkPreview.Processor.call(@httparrot <> "/missing")
  end

  test "normalizes raised adapter errors" do
    expect(LinkPreview.TestAdapter, :call, fn _, _ -> raise "adapter failure" end)

    assert {:error, %LinkPreview.Error{origin: RuntimeError, message: "adapter failure"}} =
             LinkPreview.Processor.call(@httparrot <> "/image")
  end

  test "normalizes Tesla errors carrying a reason" do
    expect(LinkPreview.TestAdapter, :call, fn _, _ -> raise Tesla.Error, reason: :timeout end)

    assert {:error, %LinkPreview.Error{origin: Tesla.Error, message: :timeout}} =
             LinkPreview.Processor.call(@httparrot <> "/image")
  end

  test "normalizes adapter exits" do
    expect(LinkPreview.TestAdapter, :call, fn _, _ -> exit(:timeout) end)

    assert {:error, %LinkPreview.Error{origin: :unknown}} =
             LinkPreview.Processor.call(@httparrot <> "/image")
  end

  test "returns an error for failed HEAD requests" do
    expect(LinkPreview.TestAdapter, :call, fn %{method: :head}, _ -> {:error, :econnrefused} end)

    assert {:error, %LinkPreview.Error{origin: LinkPreview.Requests, message: ":econnrefused"}} =
             LinkPreview.Processor.call(@httparrot <> "/image")
  end

  test "returns an error for failed GET requests" do
    expect(LinkPreview.TestAdapter, :call, fn %{method: :head} = env, _ ->
      {:ok, %{env | status: 200, headers: [{"content-type", "text/html"}]}}
    end)

    expect(LinkPreview.TestAdapter, :call, fn %{method: :get}, _ -> {:error, :timeout} end)

    assert {:error, %LinkPreview.Error{}} = LinkPreview.Processor.call(@httparrot <> "/page")
  end
end
