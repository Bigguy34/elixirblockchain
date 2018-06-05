defmodule RawBlock do
  use Timex
  defstruct previousHash: "0", hash: "0", date: Duration.now, index: 0, data: "GENSISBLOCK"
  # A helper function for creating a tuple
  def createBlock(previousHash, hash, date, index, data) do
    %RawBlock{ previousHash: previousHash, hash: hash, date: date, index: index, data: data }
  end
end
