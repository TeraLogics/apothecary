defmodule ApothecaryWeb.UploadController do
  use ApothecaryWeb, :controller

  alias Apothecary.{Packages, Docs}

  def package(conn, %{"package" => package}) do
    Packages.upsert(package.path, package.filename)
    json(conn, "Package uploaded.")
  end

  def docs(conn, %{"docs" => docs}) do
    Docs.upsert(docs.path, docs.filename)
    json(conn, "Docs uploaded.")
  end

end
