// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {DaoObjects} from "./DaoObjects.sol";

library DaoLogic {
    function createProposal(
        DaoObjects.ProposalDTO memory proposalDTO,
        uint256 proposalCount,
        mapping(uint256 => DaoObjects.Proposal) storage allProposal,
        uint8 votingDuration
    ) internal {
        DaoObjects.Proposal memory proposal = _createProposal(proposalDTO, proposalCount, votingDuration);

        allProposal[proposalCount] = proposal;
        
    }

    function _createProposal(DaoObjects.ProposalDTO memory _proposal, uint256 _proposalCount, uint8 _duration)
        private
        view
        returns (DaoObjects.Proposal memory proposal)
    {
        proposal.id = _proposalCount;
        proposal.createdOn = uint128(block.timestamp);
        proposal.deadline = block.timestamp + (uint256(_duration) * 1 days);
        proposal.description = _proposal.description;
        proposal.proposalCreator = _proposal.creator;
        return proposal;
    }
}
