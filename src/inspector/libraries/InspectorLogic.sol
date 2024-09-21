// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {InspectorObject} from "src/inspector/libraries/InspectorObjectConstant.sol";

library InspectorLogic {
    function registerInspector(
        InspectorObject.Inspector[] storage allInspectors,
        mapping(address => InspectorObject.Inspector) storage inspectorMapping,
        mapping(uint256 => InspectorObject.Inspector) storage _inspector,
        InspectorObject.InspectorDTO memory inspectorDTO
    ) internal returns (uint256) {
        InspectorObject.Inspector memory inspector;

        inspector.documents = inspectorDTO.documents;
        inspector.location = inspectorDTO.location;
        inspector.name = inspectorDTO.name;
        inspector.inspectorAddress = inspectorDTO.user;
        inspector.registrationPeriod = block.timestamp;

        inspectorMapping[inspectorDTO.user] = inspector;
        allInspectors.push(inspector);
        _inspector[allInspectors.length + 1] = inspector;
        return allInspectors.length;
    }

    function checkDuplicateAddress(mapping(address => bool) storage existingAddress, address inspectorAddress)
        private
        view
        returns (bool result)
    {
        result = existingAddress[inspectorAddress];
    }
}
