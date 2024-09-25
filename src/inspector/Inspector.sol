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
    mapping(InspectorObject.Continent => InspectorObject.Inspector[])
        private inspectorRegion;
    mapping(InspectorObject.InspectorSpecialization => InspectorObject.Inspector[])
        private specializationToInspector;
    mapping(InspectorObject.Continent => mapping(InspectorObject.InspectorSpecialization => InspectorObject.Inspector[]))
        private regionToSpecializationToInspectors;
    uint256 public inspectorCount;

    function registerInspector(
        InspectorObject.InspectorDTO memory inspectorDTO
    ) external returns (uint256 inspectorId_) {
        bool duplicateAddress = InspectorLogic.checkDuplicateAddress(
            alreadyExistingAddress,
            inspectorDTO.user
        );
        if (duplicateAddress)
            revert InspectorErrors.DuplicateAddressError(inspectorDTO.user);
        (bool result, bytes memory _name) = InspectorLogic.checkDuplicateName(
            alreadyExistingName,
            inspectorDTO.name
        );
        if (result)
            revert InspectorErrors.DuplicateUsernameError(
                bytes(inspectorDTO.name)
            );
        inspectorCount = inspectorCount + 1;
        inspectorId_ = InspectorLogic.registerInspector(
            inspectorCount,
            inspectorMapping,
            inspector,
            inspectorDTO
        );
        alreadyExistingAddress[inspectorDTO.user] = true;
        alreadyExistingName[_name] = true;
    }

    function approveInspector(uint inspectorId) external returns (bool) {
        return InspectorLogic.approveInspector(inspectorId, inspector);
    }

    function suspendInspector(uint inspectorId) external returns (bool) {
        return InspectorLogic.suspendInspector(inspectorId, inspector);
    }

    function deleteInspector(uint inspectorId) external returns (bool) {
        return InspectorLogic.deleteInspector(inspectorId, inspector);
    }

    function returnInspector(
        uint inspectorId
    ) external view returns (InspectorObject.Inspector memory) {
        return InspectorLogic.returnInspector(inspectorId, inspector);
    }

    function returnInspectorstatus(
        uint inspectorId
    ) external view returns (InspectorObject.InspectorStatus) {
        InspectorObject.Inspector memory inspector1 = InspectorLogic
            .returnInspector(inspectorId, inspector);
        return inspector1.inspectorStatus;
    }
}
