// SPDX-License-Identifier: BSL-1.0 (Boost Software License 1.0)

//--------------------------------------------------------------------------//
// Copyright 2022 serial-coder: Phuwanai Thummavet (mr.thummavet@gmail.com) //
//--------------------------------------------------------------------------//

// For more info, please refer to my article:
//  - On Medium: (coming soon)
//  - On serial-coder.com: (coming soon)

pragma solidity 0.8.17;

import "./Dependencies.sol";

// FixedMoonVault must be the contract owner of the MoonToken
contract FixedMoonVault is ReentrancyGuard {
    IMoonToken public immutable moonToken;

    constructor(IMoonToken _moonToken) {
        moonToken = _moonToken;
    }

    function deposit() external payable noReentrant {  // Apply the noReentrant modifier
        bool success = moonToken.mint(msg.sender, msg.value);
        require(success, "Failed to mint token");
    }

    function withdrawAll() external noReentrant {  // Apply the noReentrant modifier
        uint256 balance = getUserBalance(msg.sender);
        require(balance > 0, "Insufficient balance");  // Check

        // FIX: Apply checks-effects-interactions pattern
        bool success = moonToken.burnAccount(msg.sender);  // Effect (call to trusted external contract)
        require(success, "Failed to burn token");

        (success, ) = msg.sender.call{value: balance}("");  // Interaction
        require(success, "Failed to send Ether");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getUserBalance(address _user) public view returns (uint256) {
        return moonToken.balanceOf(_user);
    }
}