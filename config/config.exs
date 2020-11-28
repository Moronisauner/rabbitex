import Config

import System, only: [get_env: 1]

config :lager,
  error_logger_redirect: false,
  handlers: [level: :critical]

config :rabbitex, RabbitexQueue.Broker,
  adapter: ConduitAMQP,
  port: get_env("RMQ_PORT") || "5675",
  host: get_env("RMQ_HOST") || "localhost",
  username: get_env("RMQ_USERNAME") || "guest",
  password: get_env("RMQ_PASSWORD") || "guest"
