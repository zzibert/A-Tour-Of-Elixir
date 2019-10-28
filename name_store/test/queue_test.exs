defmodule NameStore.QueueTest do
  use ExUnit.Case
  alias NameStore.Queue

  test "application `NameStore.Queue` should be started at start" do
    case Process.whereis(Queue) do
      nil ->
        flunk("Process `NameStore.Queue` should be started at the beginning")
      pid ->
        assert true == Process.alive?(pid)
    end
  end

  test "put should add name to `NameStore.Queue`" do
    assert :added == Queue.put("Zan")
    assert ["Zan"] == :sys.get_state(Queue)
  end

  test "get should return `nil` if empty" do
    assert nil == Queue.get()
  end

  test "get should remove name from `NameStore.Queue`" do
    Queue.put("Zan")
    assert "Zan" == Queue.get()
    assert [] == :sys.get_state(Queue)
  end

  test "names should be in sorted order in `NameStore.Queue`" do
    Enum.each(["Zan", "Luka", "Andraz", "Marko"], &Queue.put/1)

    assert "Andraz" == Queue.get()
    assert "Luka" == Queue.get()
    assert "Marko" == Queue.get()
    assert "Zan" == Queue.get()
  end
end