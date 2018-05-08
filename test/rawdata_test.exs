defmodule RawChainTest do
  use ExUnit.Case
  doctest RawChain

  test "hashes date, index, previousHash, and data" do
    assert RawChain.calculateHash(1, "23", "thing", "anotherthing") =="C498E5FE8CB5B7A4DB284120964EED21F9FDDCB5163BDE1E9FD0B12CA0AFF406"
  end

  test "Create a Gensis Chain" do
    {:index, index, :hash, hash, :previousHash, previousHash, :data, data} = RawChain.createGenesisBlock()
    assert index == 0
    assert hash == "0"
    assert previousHash == "0"
    assert data == "GENSISBLOCK"
  end

  test "Create new Chain" do
    [index: index, previousHash: previousHash, data: data, hash: hash] = RawChain.createNewChain()
    assert index == 0
    assert hash == "0"
    assert previousHash == "0"
    assert data == "GENSISBLOCK"
  end

end
