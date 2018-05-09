defmodule RawChainTest do
  use ExUnit.Case
  use Timex
  doctest RawChain

  test "Create a Gensis Chain" do
    { :previousHash, previousHash, :hash, hash, _, _, :index, index, :data, data} = RawChain.createGenesisBlock()
    assert index == 0
    assert hash == "0"
    assert previousHash == "0"
    assert data == "GENSISBLOCK"
  end

  test "Create new Chain" do
    {:ok, agent}= RawChain.startChain()
    [{:previousHash, previousHash, :hash, hash, _, _, :index, index, :data, data}] = RawChain.getChain(agent)
    assert index == 0
    assert hash == "0"
    assert previousHash == "0"
    assert data == "GENSISBLOCK"
  end
  
  test "Add a block to a chain" do
    {:ok, agent} = RawChain.startChain()
    RawChain.storeNextBlock(agent, "somedata")
    [head | tail] = RawChain.getChain(agent)
    [genesis] = tail
    assert elem(head,1) == elem(genesis,1)
    assert elem(head, 7) == 1
    assert elem(head, 9) == "somedata"
      
    end

  end
