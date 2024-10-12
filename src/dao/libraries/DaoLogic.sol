// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {DaoObjects} from "./DaoObjects.sol";

library DaoLogic {
    function createProposal(
        DaoObjects.ProposalDTO memory proposalDTO,
        uint256 proposalCount,
        mapping(uint256 => DaoObjects.Proposal) storage allProposal
    ) internal {}
}
