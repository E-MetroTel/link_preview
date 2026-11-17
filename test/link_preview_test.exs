defmodule LinkPreviewTest do
  use LinkPreview.Case

  test "previews an HTML response using default parsers" do
    assert {:ok, %LinkPreview.Page{title: title, description: description}} =
             LinkPreview.create(@httparrot <> "/html")

    assert is_binary(description)
    assert is_nil(title)
  end

  test "processor accepts image responses" do
    assert {:ok, %LinkPreview.Page{images: [_]}} =
             LinkPreview.Processor.call(@httparrot <> "/image")
  end

  test "processor rejects unsupported responses" do
    assert {:error, %LinkPreview.Error{message: "unsupported response"}} =
             LinkPreview.Processor.call(@httparrot <> "/robots.txt")
  end

  describe "create" do
    test "deletage to processor" do
      url = @httparrot <> "/image"
      assert LinkPreview.create(url) == LinkPreview.Processor.call(url)
    end
  end

  describe "create!" do
    test "returns Page struct" do
      assert %LinkPreview.Page{} = LinkPreview.create!(@httparrot <> "/image")
    end

    test "raise error" do
      assert_raise LinkPreview.Error, fn -> LinkPreview.create!(@httparrot <> "/robots.txt") end
    end
  end
end
