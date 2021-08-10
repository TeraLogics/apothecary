defmodule Apothecary.HexRegistry do
  use GenServer

  require Logger

  @registry_table :package_registry

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    :ets.new(@registry_table, [:ordered_set, :named_table])

    state = %{
      build_counter: 1,
      public_dir: Application.fetch_env!(:apothecary, :public_dir),
      private_key: Application.fetch_env!(:apothecary, :private_key),
      registry_name: Application.fetch_env!(:apothecary, :registry_name)
    }

    build_registry(state.public_dir, state.registry_name, state.private_key, state.build_counter)

    {:ok, state}
  end

  def list_packages do
    :ets.tab2list(@registry_table)
    |> Enum.map(fn {_name, _counter, package_data} -> package_data end)
  end

  def list_filtered_packages(str) do
    :ets.foldr(
      fn {name, _counter, package_data}, acc ->
        if String.contains?(name, str) do
          [package_data | acc]
        else
          acc
        end
      end,
      [],
      @registry_table
    )
  end

  def build() do
    GenServer.call(__MODULE__, :build)
  end

  def handle_call(:build, _from, state) do
    counter = state.builder_counter + 1
    build_registry(state.public_dir, state.registry_name, state.private_key, counter)

    {:noreply, state, %{state | build_counter: counter}}
  end

  defp build_registry(public_dir, registry_name, private_key, counter) do
    cmd = "mix"

    args = [
      "hex.registry",
      "build",
      public_dir,
      "--name=#{registry_name}",
      "--private-key=#{private_key}"
    ]

    opts = [cd: public_dir]
    IO.inspect(args, label: "args: ")
    System.cmd(cmd, args, opts) |> IO.inspect(label: "cmd output: ")
    Logger.info("Built the package registry")

    File.mkdir_p!(public_dir <> "/metadata")

    update_table(counter)
  end

  defp update_table(counter) do
    packages =
      Apothecary.Packages.all()
      |> Enum.reduce([], &map_package/2)
      |> Enum.map(fn {name, package_data} -> {name, counter, package_data} end)

    :ets.insert(@registry_table, packages)

    # delete anything with a counter value less than current
    :ets.select_delete(@registry_table, [{{:_, :"$1", :_}, [{:<, :"$1", counter}], [true]}])
  end

  defp map_package({name, versions}, acc) do
    versions =
      versions
      |> Enum.map(&Map.take(&1, [:version, :dependencies]))
      |> Enum.sort(&(Version.compare(&1.version, &2.version) == :gt))

    %{version: latest_version} = List.first(versions)
    metadata = Apothecary.Packages.get_metadata(name, latest_version)

    [
      {name,
       %{
         name: name,
         versions: versions,
         latest_version: latest_version,
         version_count: length(versions),
         metadata: metadata
       }}
      | acc
    ]
  end
end
