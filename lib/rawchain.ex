defmodule RawChain do
  use Agent
  use Timex
  @moduledoc """
  This is a simple data store for the raw block chain
  """
  def storeNextBlock(chain, data) do 
    currentDate = Duration.now 
    previousBlock = getCurrentBlock(chain)
    newIndex = previousBlock.index + 1
    newHash = calculateHash(newIndex, previousBlock.hash, currentDate, data)
    newBlock = createBlock(previousBlock.hash, newHash, currentDate, newIndex, data)
    Agent.update(chain, &[newBlock | &1])
  end

  defp createBlock(previousHash, hash, date, index, data) do
    { :previousHash, previousHash, :hash, hash, :date, date, :index, index,:data, data }
  end

  def calculateHash(index, previousHash, timestamp, data) do
    :crypto.hash(:sha256, "#{index}#{previousHash}#{timestamp}#{data}") |> Base.encode16
  end

  def getCurrentBlock(chain) do
    Agent.get(chain, :hash)     
  end

  def createGenesisBlock() do 
    createBlock("0", "0", Duration.now, 0, "GENSISBLOCK")
  end

  def createNewChain() do
    [createGenesisBlock()]
  end
end
