defmodule RawChainTest do
  use ExUnit.Case
  use Timex
  doctest RawChain

  test "Create a Gensis Chain" do
    { :previousHash, previousHash, :hash, hash, _, _, :index, index, :data, data} = RawChain.createGenesisBlock()
    # verify that we are creating a genesis tuple
    assert index == 0
    assert hash == "0"
    assert previousHash == "0"
    assert data == "GENSISBLOCK"
  end

  test "Create new Chain" do
    {:ok, agent}= RawChain.startChain()
    [{:previousHash, previousHash, :hash, hash, _, _, :index, index, :data, data}] = RawChain.getChain(agent)
    # verify that this is truely a genesis block contained in the chain
    assert index == 0
    assert hash == "0"
    assert previousHash == "0"
    assert data == "GENSISBLOCK"
  end
  
  test "Add a block to a chain" do
    # start a new chain
    {:ok, agent} = RawChain.startChain()
    # add a new block with some data
    RawChain.storeNextBlock(agent, "somedata")
    #get the current chain, and break it apart
    [head | tail] = RawChain.getChain(agent)
    [genesis] = tail
    #verify that the previousHash of the latest block matches the hash of the genesis block
    assert elem(head,1) == elem(genesis,1)
    #verify that the index got increamented
    assert elem(head, 7) == 1
    #verify that the data was properly stored
    assert elem(head, 9) == "somedata"
      
    end

  end
