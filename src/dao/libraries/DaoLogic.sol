// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {DaoObjects} from "./DaoObjects.sol";

library DaoLogic {
    function createProposal(
        DaoObjects.ProposalDTO memory proposalDTO,
        uint256 proposalCount,
        mapping(uint256 => DaoObjects.Proposal) storage allProposal,
        uint256 votingDuration
    ) internal view {
        DaoObjects.Proposal memory proposal = _createProposal(proposalDTO, proposalCount, votingDuration);
    }

    function _createProposal(DaoObjects.ProposalDTO memory _proposal, uint256 _proposalCount, uint256 _duration)
        private
        view
        returns (DaoObjects.Proposal memory proposal)
    {
        proposal.id = _proposalCount;
        proposal.createdOn = uint128(block.timestamp);
        proposal.deadline = uint128(block.timestamp) + _duration;
        proposal.description = _proposal.description;
        proposal.proposalCreator = _proposal.creator;
    }
}
