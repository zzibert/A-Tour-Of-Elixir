defmodule CardFetcher.CardWorker do
  @cards_url "https://api.hearthstonejson.com/v1/33402/enUS/cards.json"

  use GenServer

  alias Kafka.Producer

  defmodule State do
    defstruct cards: []
  end

  # API #

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_cards(table) do
    GenServer.call(__MODULE__, {:get_cards, table})
  end

  def create_cards_by_name() do
    GenServer.call(__MODULE__, :create_cards_by_name)
  end

  def create_cards_by_attack() do
    GenServer.call(__MODULE__, :create_cards_by_attack)
  end

  def create_cards_by_attack_and_health() do
    GenServer.call(__MODULE__, :create_cards_by_attack_and_health)
  end

  def query_cards_by_name(name) do
    GenServer.call(__MODULE__, {:query_cards_by_name, name})
  end

  def query_cards_by_attack(attack) do
    GenServer.call(__MODULE__, {:query_cards_by_attack, attack})
  end

  def query_cards_by_attack_and_health(attack, health) do
    GenServer.call(__MODULE__, {:query_cards_by_attack_and_health, attack, health})
  end

  def count_rows(table) do
    GenServer.call(__MODULE__, {:count_rows, table})
  end

  # CALLBACKS #

  def init([]) do
    {:ok, %State{}}
  end

  def handle_call({:get_cards, table}, _from, state) do
    {:ok, body} = call(@cards_url)

    Poison.decode!(body)
    |> Enum.reject(fn card -> is_nil(card["attack"]) end)
    |> Enum.reject(fn card -> is_nil(card["health"]) end)
    |> Enum.map(fn card -> Poison.encode!(%{"name" => card["name"], "attack" => card["attack"], "health" => card["health"]}) end)
    |> Enum.each(fn card -> Producer.send_card(card, table) end)

    {:reply, [], state}
  end

  def handle_call({:query_cards_by_name, name}, _from, state) do
    statement = "SELECT * FROM cards_by_name where name = ?"
    cards = Xandra.execute!(:xandra, statement, [{"text", name}], pool: Xandra.Cluster)

    {:reply, cards, state}
  end

  def handle_call({:query_cards_by_attack, attack}, _from, state) do
    statement = "SELECT * FROM cards_by_attack where attack = ?"
    cards = Xandra.execute!(:xandra, statement, [{"int", attack}], pool: Xandra.Cluster)

    {:reply, cards, state}
  end

  def handle_call({:query_cards_by_attack_and_health, attack, health}, _from, state) do
    statement = "SELECT * FROM cards_by_attack_and_health where attack = ? and health = ?"
    cards = Xandra.execute!(:xandra, statement, [{"int", attack}, {"int", health}], pool: Xandra.Cluster)

    {:reply, cards, state}
  end

  def handle_call({:count_rows, table}, _from, state) do
    statement = "SELECT COUNT(*) FROM #{table}"
    number = Xandra.execute!(:xandra, statement, %{}, pool: Xandra.Cluster)
    {:reply, number, state}
  end

  def handle_call(:create_cards_by_name, _from, state) do
    statement = "CREATE TABLE cards_by_name (name text, attack int, health int, PRIMARY KEY((name), attack))"
    Xandra.execute!(:xandra, statement, %{}, pool: Xandra.Cluster)
    {:reply, "CREATED CARDS BY NAME", state}
  end

  def handle_call(:create_cards_by_attack, _from, state) do
    statement = "CREATE TABLE cards_by_attack (name text, attack int, health int, PRIMARY KEY((attack), name))"
    Xandra.execute!(:xandra, statement, %{}, pool: Xandra.Cluster)
    {:reply, "CREATED CARDS BY ATTACK", state}
  end

  def handle_call(:create_cards_by_attack_and_health, _from, state) do
    statement = "CREATE TABLE cards_by_attack_and_health (name text, attack int, health int, PRIMARY KEY((attack, health), name))"
    Xandra.execute!(:xandra, statement, %{}, pool: Xandra.Cluster)
    {:reply, "CREATED CARDS BY ATTACK AND HEALTH", state}
  end

  # Helper Functions #

  def call(url) do
    url
    |> HTTPoison.get()
    |> case do
      {:ok, %HTTPoison.Response{status_code: code, body: body}}
      when code >= 200 and code <= 300 ->
        {:ok, body}

      _ ->
        {:error, :response_invalid}
    end
  end
end
