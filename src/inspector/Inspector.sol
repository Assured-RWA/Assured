// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {InspectorObject} from "src/inspector/libraries/InspectorObjectConstant.sol";
import {InspectorLogic} from "src/inspector/libraries/InspectorLogic.sol";
// import {InspectorErrors} from "src/inspector/libraries/InspectorErrors.sol";

contract Inspector {
    mapping(uint256 => InspectorObject.Inspector) private inspector;
    mapping(address => InspectorObject.Inspector) private inspectorMapping;
    // uint256[] public
    mapping(bytes => bool) private alreadyExistingName;
    mapping(address => bool) private alreadyExistingAddress;
    mapping(InspectorObject.Continent => InspectorObject.Inspector[]) private inspectorRegion;
    mapping(InspectorObject.InspectorSpecialization => InspectorObject.Inspector[]) private specializationToInspector;
    mapping(
        InspectorObject.Continent => mapping(InspectorObject.InspectorSpecialization => InspectorObject.Inspector[])
    ) private regionToSpecializationToInspectors;
    uint256 public inspectorCount;

    function registerInspector(InspectorObject.InspectorDTO memory inspectorDTO)
        external
        returns (uint256 inspectorId_)
    {
        bytes memory _name =
            InspectorLogic.checkForDuplicateAndAddress(alreadyExistingAddress, alreadyExistingName, inspectorDTO);
        inspectorCount = inspectorCount + 1;
        inspectorId_ = InspectorLogic.registerInspector(inspectorCount, inspectorMapping, inspector, inspectorDTO);
        alreadyExistingAddress[inspectorDTO.user] = true;
        alreadyExistingName[_name] = true;
    }

    function approveInspector(uint256 inspectorId) external returns (bool) {
        return InspectorLogic.approveInspector(inspectorId, inspector);
    }

    function suspendInspector(uint256 inspectorId) external returns (bool) {
        return InspectorLogic.suspendInspector(inspectorId, inspector);
    }

    function returnInspector(uint256 inspectorId) external view returns (InspectorObject.Inspector memory) {
        return InspectorLogic.returnInspector(inspectorId, inspector);
    }
}
