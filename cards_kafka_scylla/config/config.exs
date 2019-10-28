use Mix.Config

config :kafka_ex,
  brokers: [
    {"localhost", 9092}
  ],
  consumer_group: "kafka_ex",
  disable_default_worker: false,
  sync_timeout: 3000,
  max_restarts: 10,
  max_seconds: 60,
  use_ssl: false,
  kafka_version: "0.10.0"

  config :scylla, scylla_keyspace: "USE hearthstone;"

  config :xandra, Xandra,
    name: :xandra,
    nodes: ["localhost:9042"],
    pool: Xandra.Cluster,
    underlying_pool: DBConnection.Poolboy,
    pool_size: 10,
    authentication:
      {Xandra.Authenticator.Password, [username: "dev_master", password: "dev_master_pass"]}
