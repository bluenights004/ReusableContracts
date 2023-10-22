// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//to demo on how to store integer data in bytes and then get the data in the form of integer.

contract BytesExample {
    
    bytes public data2;

    function setInteger(uint256 _integer) public {
        data2 = abi.encode(_integer);  // Encodes the integer as bytes
    }
    
    function getInteger() public view returns (uint256) {
        return abi.decode(data2, (uint256));  // Decodes the bytes back to an integer
    }
}



