// SPDX-License-Identifier: BSL-1.0 (Boost Software License 1.0)

//--------------------------------------------------------------------------//
// Copyright 2022 serial-coder: Phuwanai Thummavet (mr.thummavet@gmail.com) //
//--------------------------------------------------------------------------//

// For more info, please refer to my article:
//  - On Medium: (coming soon)
//  - On serial-coder.com: (coming soon)

pragma solidity 0.8.17;

contract InsecureDonation {
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function buyMeACoffee() external payable {
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function collectEthers(address payable _to, uint256 _amount) external {
        require(tx.origin == owner, "Not owner");

        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
}