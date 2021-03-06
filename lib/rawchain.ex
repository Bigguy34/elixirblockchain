defmodule RawChain do
  use Agent
  @moduledoc """
  This is a simple data store for the raw block chain
  """
  # stores the next block in the chain, will also handle creating the timestamp and increamenting the index, and hashing the new block.
  def storeNextBlock(agent, data) do 
    currentDate = Timex.now 
    previousBlock = getCurrentBlock(agent)
    newIndex = previousBlock.index + 1
    newHash = calculateHash(newIndex, previousBlock.previousHash, currentDate, data)
    newBlock = RawBlock.createBlock(previousBlock.previousHash, newHash, currentDate, newIndex, data)
    Agent.update(agent, fn list -> [newBlock | list] end)
  end
  
  
  # function for creating the hash for a new block
  def calculateHash(index, previousHash, timestamp, data) do
    {:ok, default_str} = Timex.format(timestamp, "{ISO:Extended}")
    :crypto.hash(:sha256, "#{index}#{previousHash}#{default_str}#{data}") |> Base.encode16
  end

  # function for returning the last inserted  block in the chain
  def getCurrentBlock(agent) do
    Agent.get(agent, fn [head] -> head end)     
  end
  
  # function creating a new chain
  defp createNewChain() do
    [%RawBlock{}]
  end

  # function for getting the entire chain
  def getChain(agent) do 
    Agent.get(agent, fn list -> list end)
  end

  # starts a new chain with the agent
  def startChain() do
    Agent.start_link fn -> createNewChain() end
  end
end
