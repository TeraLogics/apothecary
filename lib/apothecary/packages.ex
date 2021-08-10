defmodule Apothecary.Packages do
  alias Apothecary.Hex

  def all do
    public_dir = Application.fetch_env!(:apothecary, :public_dir)
    hex_name = Application.fetch_env!(:apothecary, :registry_name)
    packages_dir = Path.join([public_dir, "packages"])
    packages = File.ls!(packages_dir)

    Enum.map(packages, fn package ->
      package_path = Path.join(packages_dir, package)

      signed_proto =
        package_path
        |> File.read!()
        |> :zlib.gunzip()
        |> :hex_registry.decode_signed()

      {:ok, release_info} = :hex_registry.decode_package(signed_proto.payload, hex_name, package)
      {package, release_info}
    end)
    |> Enum.into(%{})
  end

  def get_metadata(package, version) do
    public_dir = Application.fetch_env!(:apothecary, :public_dir)

    file_path = Path.join([public_dir, "tarballs", "#{package}-#{version}.tar"])
    binary = File.read!(file_path)

    {:ok, [{'metadata.config', metadata}]} =
      :erl_tar.extract({:binary, binary}, [{:files, ['metadata.config']}, :memory, :compressed])

    # save to file and extract
    file_path = Path.join([public_dir, "metadata", "#{package}.metadata"])
    {:ok, fd} = File.open(file_path, [:write])
    :ok = IO.write(fd, metadata)
    File.close(fd)

    {:ok, values} = :file.consult(file_path)

    values
    |> Enum.into(%{})
    |> Map.take(["description", "links"])
  end

  def upsert(path, name) do
    public_dir = Application.fetch_env!(:apothecary, :public_dir)
    file_path = Path.join([public_dir, "tarballs", name])
    File.cp!(path, file_path)
    # here is where we run the command to reindex
    Apothecary.HexRegistry.build()
  end

  def delete(name) do
    public_dir = Application.fetch_env!(:apothecary, :public_dir)
    file_path = Path.join([public_dir, "tarballs", name])
    File.rm_rf!(file_path)
    Apothecary.HexRegistry.build()
  end
end
