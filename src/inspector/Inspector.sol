// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {InspectorObject} from "src/inspector/libraries/InspectorObjectConstant.sol";
import {InspectorLogic} from "src/inspector/libraries/InspectorLogic.sol";
import {InspectorErrors} from "src/inspector/libraries/InspectorErrors.sol";

contract Inspector {
    mapping(uint256 => InspectorObject.Inspector) private inspector;
    mapping(address => InspectorObject.Inspector) private inspectorMapping;
    mapping(bytes => bool) private alreadyExistingName;
    mapping(address => bool) private alreadyExistingAddress;
    mapping(InspectorObject.Continent => Inspector[]) private inspectorRegion;
    InspectorObject.Inspector[] private pendingInspector;
    InspectorObject.Inspector[] private approvedInspector;
    InspectorObject.Inspector[] private blacklistedInspector;
    InspectorObject.Inspector[] private allInspectors;

    function registerInspector(InspectorObject.InspectorDTO memory inspectorDTO)
        external
        returns (uint256 inspectorId_)
    {
        bool duplicateAddress = InspectorLogic.checkDuplicateAddress(alreadyExistingAddress, inspectorDTO.user);
        if (duplicateAddress) revert InspectorErrors.DuplicateAddressError(inspectorDTO.user);
        
        inspectorId_ = InspectorLogic.registerInspector(allInspectors, inspectorMapping, inspector, inspectorDTO);
        alreadyExistingAddress[inspectorDTO.user] = true;
    }

    function getAllInspectors() external view returns (InspectorObject.Inspector[] memory) {
        return allInspectors;
    }
}
