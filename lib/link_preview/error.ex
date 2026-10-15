defmodule LinkPreview.Error do
  @type t :: %__MODULE__{message: term(), origin: module() | atom() | nil}

  defexception message: "", origin: nil
end
