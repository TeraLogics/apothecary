defmodule ApothecaryWeb.StaticRuntimePlug do
  def init(opts), do: Plug.Static.init(opts)

  def call(conn, opts) do
    runtime_opts = Map.put(opts, :from, Application.fetch_env!(:apothecary, :public_dir))
    Plug.Static.call(conn, runtime_opts)
  end
end
