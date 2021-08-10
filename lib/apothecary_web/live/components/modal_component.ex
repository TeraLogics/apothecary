defmodule ApothecaryWeb.ModalComponent do
  use ApothecaryWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="phx-modal"
         phx-window-keydown="toggle-modal"
         phx-key="escape"
         phx-capture-click="toggle-modal">
      <div class="phx-modal-content">
        <a href="#" phx-click="toggle-modal" class="phx-modal-close">
          &times;
        </a>
        <%= live_component @socket, @component, client_origin: @client_origin %>
      </div>
    </div>
    """
  end
end
