// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {DaoObjects } from "./libraries/DaoObjects.sol";

contract Dao {

    uint256 public quorum;
    uint256 public votingDuration;
    uint256 public proposalCount;
    mapping (address => uint256) public membershipBalance;
    mapping (uint256 => mapping (address => bool)) private hasVoted;
    mapping (address => bool) private isBlacklisted;
    mapping (uint => DaoObjects.Proposal) public allProposals;
    
    receive() external payable {}
}
