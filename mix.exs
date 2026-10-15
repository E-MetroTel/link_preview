defmodule LinkPreview.Mixfile do
  use Mix.Project

  @version "1.1.0"

  def project do
    [
      app: :link_preview,
      deps: deps(),
      description: description(),
      docs: [
        extras: ["README.md", "CHANGELOG.md"]
      ],
      elixir: "~> 1.20",
      elixirc_paths: elixirc_paths(Mix.env()),
      homepage_url: "https://appunite.com",
      name: "Link Preview",
      package: package(),
      source_url: "https://github.com/appunite/link_preview",
      test_coverage: [
        tool: ExCoveralls
      ],
      version: @version,
      elixirc_options: [no_warn_undefined: [HtmlEntities, Mogrify, Tempfile]]
    ]
  end

  defp description do
    """
    LinkPreview is a package that tries to receive meta information from given http(s) address.
    Generated page struct includes website title, description, images and more.
    """
  end

  defp package do
    [
      files: ["lib", "config", "mix.exs", "README.md", "CHANGELOG.md"],
      maintainers: ["Tobiasz Małecki", "Karol Wojtaszek"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/appunite/link_preview",
        "Sponsor" => "https://appunite.com"
      }
    ]
  end

  def cli do
    [
      preferred_envs: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ]
    ]
  end

  def application do
    [extra_applications: [:inets, :logger, :ssl]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # required
      {:floki, "~> 0.38"},
      {:tesla, "~> 1.22"},

      # optional
      {:html_entities, "~> 0.5", optional: true},
      {:mogrify, "~> 0.9", optional: true},
      {:tempfile, github: "E-MetroTel/tempfile", optional: true, branch: "elixir-11"},

      # testing/docs
      {:excoveralls, "~> 0.18.5", only: :test},
      {:ex_doc, "~> 0.40", only: :dev},
      {:httparrot, "~> 1.5", only: :test},
      {:mox, "~> 1.2", only: :test}
    ]
  end
end
