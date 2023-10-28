// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This simplified contract shows on how to limit minting per block. 
// It shows how reliable is block.number keyword in helping to limit the minting per block.

contract maxBlock {

    error MaxMintPerBlockExceeded();

     event MaxMintPerBlockChanged(uint256 indexed oldMaxMintPerBlock, uint256 indexed newMaxMintPerBlock);

    // @notice USDe minted per block
  mapping(uint256 => uint256) public mintedPerBlock;

  /// @notice max minted USDe allowed per block
  uint256 public maxMintPerBlock;

  modifier belowMaxMintPerBlock(uint256 mintAmount) {
    if (mintedPerBlock[block.number] + mintAmount > maxMintPerBlock) revert MaxMintPerBlockExceeded();
    _;
  }

  constructor(
 uint256 _maxMintPerBlock) {
// Set the max mint/redeem limits per block
    _setMaxMintPerBlock(_maxMintPerBlock);
}


function mint (uint256 usde_amount) public
belowMaxMintPerBlock(usde_amount)
{

 // Add to the minted amount in this block
    mintedPerBlock[block.number] += usde_amount;
}

 function _setMaxMintPerBlock(uint256 _maxMintPerBlock) internal {
    uint256 oldMaxMintPerBlock = maxMintPerBlock;
    maxMintPerBlock = _maxMintPerBlock;
    emit MaxMintPerBlockChanged(oldMaxMintPerBlock, maxMintPerBlock);
  }

  function multiple_mints (uint256 firstset, uint256 secondset) public {
       mint(firstset);
       mint(secondset);

  }


}