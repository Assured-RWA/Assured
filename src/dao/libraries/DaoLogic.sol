// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {DaoObjects} from "./DaoObjects.sol";

library DaoLogic {
    function createProposal(
        DaoObjects.ProposalDTO memory proposalDTO,
        uint256 proposalCount,
        mapping(uint256 => DaoObjects.Proposal) storage allProposal
    ) internal {
        DaoObjects.Proposal memory proposal = _createPropsal(proposalDTO, proposalCount);
    }


    function _createPropsal(DaoObjects.ProposalDTO memory _proposal, uint256 _proposalCount) private view returns(DaoObjects.Proposal memory proposal) {
        proposal.id = _proposalCount;
        proposal.createdOn = uint128(block.timestamp);
        proposal.deadline = uint128(block.timestamp) + 1 days;
        proposal.description = _proposal.description;
        proposal.proposalCreator = _proposal.creator;
    }
}
