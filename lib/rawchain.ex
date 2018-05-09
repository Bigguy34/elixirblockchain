defmodule RawChain do
  use Agent
  use Timex
  @moduledoc """
  This is a simple data store for the raw block chain
  """
  def storeNextBlock(agent, data) do 
    currentDate = Timex.now 
    previousBlock = getCurrentBlock(agent)
    previousHash = elem(previousBlock, 1)
    newIndex = elem(previousBlock, 7) + 1
    newHash = calculateHash(newIndex, previousHash, currentDate, data)
    newBlock = createBlock(previousHash, newHash, currentDate, newIndex, data)
    Agent.update(agent, fn list -> [newBlock | list] end)
  end

  defp createBlock(previousHash, hash, date, index, data) do
    { :previousHash, previousHash, :hash, hash, :date, date, :index, index,:data, data }
  end

  def calculateHash(index, previousHash, timestamp, data) do
    {:ok, default_str} = Timex.format(timestamp, "{ISO:Extended}")
    :crypto.hash(:sha256, "#{index}#{previousHash}#{default_str}#{data}") |> Base.encode16
  end

  def getCurrentBlock(agent) do
    Agent.get(agent, fn [head] -> head end)     
  end

  def createGenesisBlock() do 
    createBlock("0", "0", Duration.now, 0, "GENSISBLOCK")
  end

  defp createNewChain() do
    [createGenesisBlock()]
  end

  def getChain(agent) do 
    Agent.get(agent, fn list -> list end)
  end

  def startChain() do
    Agent.start_link fn -> createNewChain() end
  end
end
