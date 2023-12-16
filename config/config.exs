import Config

env_config = "#{config_env()}.exs" |> Path.expand(__DIR__)

if File.exists?(env_config) do
  import_config env_config
end
