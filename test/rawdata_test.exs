defmodule RawChainTest do
  use ExUnit.Case
  use Timex
  doctest RawChain

  test "Create a Gensis Chain" do
    rawBlock = %RawBlock{}
    # verify that we are creating a genesis tuple
    assert rawBlock.index == 0
    assert rawBlock.hash == "0"
    assert rawBlock.previousHash == "0"
    assert rawBlock.data == "GENSISBLOCK"
  end

  test "Create new Chain" do
    {:ok, agent}= RawChain.startChain()
    [rawBlock] = RawChain.getChain(agent)
    # verify that this is truely a genesis block contained in the chain
    assert rawBlock.index == 0
    assert rawBlock.hash == "0"
    assert rawBlock.previousHash == "0"
    assert rawBlock.data == "GENSISBLOCK"
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
    assert head.previousHash == genesis.previousHash
    #verify that the index got increamented
    assert head.index == 1
    #verify that the data was properly stored
    assert head.data == "somedata"
      
    end

  end
