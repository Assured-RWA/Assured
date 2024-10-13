// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC20} from "../../lib/solmate/src/tokens/ERC20.sol";
import {DaoLogic} from "./libraries/DaoLogic.sol";
import {DaoObjects} from "./libraries/DaoObjects.sol";

contract Dao is ERC20("assured", "assured", 2) {
    uint256 public quorum;
    uint8 public votingDuration;
    uint256 public proposalCount;
    mapping(address => bool) public isMembers;
    mapping(uint256 => mapping(address => bool)) private hasVoted;
    mapping(address => bool) private isBlacklisted;
    mapping(uint256 => DaoObjects.Proposal) public allProposals;
    address public deployer;
    
    /**
    *@dev when deployed , it automatically mints to owner;
    */
    constructor() {
        deployer = msg.sender;
        _mint(deployer, 100_000_000_000_000);
        votingDuration = 3;
        isMembers[deployer] = true;
    }

    function createProposal(DaoObjects.ProposalDTO memory proposalDTO) external {
        proposalCount = proposalCount + 1;
        DaoLogic.createProposal(proposalDTO, proposalCount, allProposals, votingDuration);
    }

    function changeVotingDuration(uint8 _duration) private {
        require(_duration > 0, "duration period must be greater than zero");
        votingDuration = _duration;
    }

    receive() external payable {}
}
