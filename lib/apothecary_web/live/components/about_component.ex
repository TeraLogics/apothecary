defmodule ApothecaryWeb.AboutComponent do
  use ApothecaryWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="about">
      <h2 style="color:#4f28a7;">Uploads</h2>
      <p>
        Packages and documentation can be uploaded via API endpoints. After uploading a package, the
        repository will be automatically re-indexed and active users will be notified to refresh their window.
      </p>
      <p>
        <svg style="color:#ffc107;vertical-align:text-bottom;margin-right:5px;" height="24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false" data-prefix="far" data-icon="exclamation-triangle" class="svg-inline--fa fa-exclamation-triangle fa-w-18" role="img" viewBox="0 0 576 512"><path fill="currentColor" d="M248.747 204.705l6.588 112c.373 6.343 5.626 11.295 11.979 11.295h41.37a12 12 0 0 0 11.979-11.295l6.588-112c.405-6.893-5.075-12.705-11.979-12.705h-54.547c-6.903 0-12.383 5.812-11.978 12.705zM330 384c0 23.196-18.804 42-42 42s-42-18.804-42-42 18.804-42 42-42 42 18.804 42 42zm-.423-360.015c-18.433-31.951-64.687-32.009-83.154 0L6.477 440.013C-11.945 471.946 11.118 512 48.054 512H527.94c36.865 0 60.035-39.993 41.577-71.987L329.577 23.985zM53.191 455.002L282.803 57.008c2.309-4.002 8.085-4.002 10.394 0l229.612 397.993c2.308 4-.579 8.998-5.197 8.998H58.388c-4.617.001-7.504-4.997-5.197-8.997z"/></svg>
        Uploading an existing package version will replace it.
      </p>
      <p>
        Publish a package:
        <pre style="font-size:1.5rem;">curl -F 'package=@your_package-1.0.0.tar' <%= @client_origin %>/api/upload-package</pre>
      </p>

      <p>
        Publish docs:
        <pre style="font-size:1.5rem;">curl -F 'docs=@your_package-1.0.0.tar' <%= @client_origin %>/api/upload-docs</pre>
      </p>
    </div>
    """
  end
end
