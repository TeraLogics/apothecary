import Config

secret_key_base =
  System.get_env(
    "APOTHECARY_SECRET_KEY_BASE",
    "EDuSEbqbbe7R9lmMk92wqC/dCWTkcNcrabL100UVNGL9JxY4xA4B7hFI6n9PbF/R"
  )

config :apothecary, ApothecaryWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("APOTHECARY_PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [host: System.fetch_env!("HOSTNAME"), port: 80],
  secret_key_base: secret_key_base

config :apothecary, registry_name: System.get_env("APOTHECARY_REPO_NAME", "apothecary")

# grab and validate required directories and files
directory = System.get_env("APOTHECARY_DIRECTORY", "/apothecary")
public_directory = directory <> "/public"
private_key = System.get_env("APOTHECARY_PRIVATE_KEY", directory <> "/private_key.pem")

unless File.exists?(directory) do
  raise "'#{directory}' is set as the Apothecary directory but it doesn't exist. You can change the location of the directory by setting $APOTHECARY_DIRECTORY."
end

unless File.exists?(public_directory) do
  raise "'#{public_directory}' doesn't exist."
end

unless File.exists?(private_key) do
  raise "'#{private_key}' is set as the private key but it doesn't exist. You can change the location of the key file by setting $APOTHECARY_PRIVATE_KEY."
end

config :apothecary,
  public_dir: public_directory,
  private_key: private_key
