defmodule LinkPreview.Parsers.BasicTest do
  use ExUnit.Case, async: false

  test "custom parsers can override one field and inherit the other defaults" do
    [{parser, _binary}] =
      Code.compile_string("""
      defmodule LinkPreview.CustomTestParser do
        alias LinkPreview.Page
        use LinkPreview.Parsers.Basic
        def title(%Page{} = page, _body), do: %Page{page | title: "Custom title"}
      end
      """)

    on_exit(fn ->
      :code.purge(LinkPreview.CustomTestParser)
      :code.delete(LinkPreview.CustomTestParser)
    end)

    page = %LinkPreview.Page{}
    assert parser.title(page, "") == %{page | title: "Custom title"}
    assert parser.description(page, "") == page
    assert parser.images(page, "") == page
  end
end
