// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {InspectorObject} from "src/inspector/libraries/InspectorObjectConstant.sol";

contract Inspector {
    mapping(uint256 => InspectorObject.Inspector ) private inspector;
    mapping(address => InspectorObject.Inspector ) private inspectorMapping;
    mapping(string => bool) private alreadyExistingName;
    mapping(InspectorObject.Continent => Inspector[]) private inspectorRegion;
    InspectorObject.Inspector[] private pendingInspector;
    InspectorObject.Inspector[] private approvedInspector;
    InspectorObject.Inspector[] private blacklistedInspector;
    InspectorObject.Inspector[] private allInspectors;

    function registerInspector(InspectorObject.InspectorDTO memory inspectorDTO) external view returns(uint256 inspectorId_) {
        return 1;
    }
    function convertToLowerCase(string memory input) external pure returns (string memory) {
        return InspectorObject.convertToLowerCase(input);
    }

    function getAllInspectors() external view returns(uint256[] memory) {
        uint256[] memory io;
        return io;
    }
}
