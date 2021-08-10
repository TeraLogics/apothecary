defmodule ApothecaryWeb.IndexLive do
  use ApothecaryWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       packages: Apothecary.HexRegistry.list_packages(),
       expanded_packages: [],
       selected_versions: %{},
       filter_text: "",
       show_modal: false,
       client_origin: get_connect_params(socket)["_origin"]
     )}
  end

  def handle_event("click-package", %{"package" => package, "version" => version}, socket) do
    expanded_packages =
      if package in socket.assigns.expanded_packages do
        List.delete(socket.assigns.expanded_packages, package)
      else
        [package | socket.assigns.expanded_packages]
      end

    selected_version =
      socket.assigns.packages
      |> Enum.find(&(&1.name == package))
      |> Map.get(:versions)
      |> Enum.find(&(&1.version == version))

    socket =
      assign(socket,
        expanded_packages: expanded_packages,
        selected_versions: Map.put(socket.assigns.selected_versions, package, selected_version)
      )

    {:noreply, socket}
  end

  def handle_event("click-version", %{"package" => package, "version" => version}, socket) do
    selected_version =
      socket.assigns.packages
      |> Enum.find(&(&1.name == package))
      |> Map.get(:versions)
      |> Enum.find(&(&1.version == version))

    socket =
      assign(socket,
        selected_versions: Map.put(socket.assigns.selected_versions, package, selected_version)
      )

    {:noreply, socket}
  end

  def handle_event("filter", %{"value" => ""}, socket) do
    {:noreply, assign(socket, packages: Apothecary.HexRegistry.list_packages())}
  end

  def handle_event("filter", %{"value" => value}, socket) do
    {:noreply, assign(socket, packages: Apothecary.HexRegistry.list_filtered_packages(value))}
  end

  def handle_event("toggle-modal", _, socket) do
    {:noreply, update(socket, :show_modal, &(!&1))}
  end
end
