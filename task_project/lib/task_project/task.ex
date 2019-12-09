defmodule TaskProject.Task do
  use Task, restart: :permanent

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(number) do
    IO.inspect "trololo, #{number}"
    Process.sleep(2_000)
    if number < 100 do
      run(number * 2)
    end
  end
end