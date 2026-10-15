[![Build Status](https://travis-ci.org/appunite/link_preview.svg?branch=master)](https://travis-ci.org/appunite/link_preview)
[![Coverage Status](https://coveralls.io/repos/github/appunite/link_preview/badge.svg?branch=master)](https://coveralls.io/github/appunite/link_preview?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/link_preview.svg?style=flat&colorB=6B4D90)](https://hex.pm/packages/link_preview)

# LinkPreview

LinkPreview is a package that tries to receive meta information from given http(s) address

## Installation

1. Add link_preview to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:link_preview, "~> 1.0.1"}
    ]
  end
  ```

## Development

The `.tool-versions` file selects Elixir 1.20.4 and Erlang/OTP 29.1.2.
Run `mix deps.get`, `mix test`, and `mix coveralls`. Tests use a local
HTTParrot server on port 8888 and require ImageMagick (`identify`) for image-size
filtering. Optional Mogrify and Tempfile applications start automatically when
included by the consuming project.

HTTP requests follow redirects and decompress responses, with a 32 MiB limit
on decompressed bodies.

## Example usage

You just need to execute:

```elixir
LinkPreview.create("www.yahoo.pl")
```

in response you'll receive

```elixir
{:ok, %LinkPreview.Page{
  description: "News, email and search are just the beginning. Discover more every day. Find your yodel.",
  images: [%{url: "https://s.yimg.com/dh/ap/default/130909/y_200_a.png"}],
  original_url: "www.yahoo.pl",
  title: "Yahoo",
  website_url: "yahoo.com"
}}
```

## License

Copyright 2017 Tobiasz Małecki <tobiasz.malecki@appunite.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
