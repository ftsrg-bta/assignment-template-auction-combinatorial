// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.x;

contract Lock {
    uint public unlockTime;
    address payable public owner;

    event Withdrawn(uint amount, uint when);

    constructor(uint _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    function withdraw() external {
        require(
	    block.timestamp >= unlockTime,
            "You can't withdraw yet"
        );
        require(msg.sender == owner, "You aren't the owner");

	uint amount = address(this).balance;
        owner.transfer(amount);
        emit Withdrawn(amount, block.timestamp);
    }
}
