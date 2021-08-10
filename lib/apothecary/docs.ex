defmodule Apothecary.Docs do

  def all do
    public_dir = Application.fetch_env!(:apothecary, :public_dir)
    docs_dir = Path.join(public_dir, "docs")
    docs_dir
    |> File.ls!()
    |> Enum.reduce(%{}, fn doc,acc -> 
      [name,version] = String.split(doc, "-")
      version_path = Path.join([public_dir, "docs", doc]) 
      default = %{
        name: name,
        versions: %{
          version => version_path
        }
      }
      Map.update(acc, name, default, fn existing -> 
        put_in(existing, [:versions, version], version_path)
      end)
    end)
  end


  def upsert(path, name) do
    public_dir = Application.fetch_env!(:apothecary, :public_dir)
    ext = Path.extname(name)
    basename = Path.basename(name, ext)
    extract_dir = Path.join([public_dir, "docs", basename])
    File.rm_rf!(extract_dir)
    File.mkdir_p!(extract_dir)
    :erl_tar.extract(path, cwd: extract_dir)
  end

  def delete(name) do
    public_dir = Application.fetch_env!(:apothecary, :public_dir)
    docs_dir = Path.join([public_dir, "docs", name])
    File.rm_rf!(docs_dir)
  end
end
