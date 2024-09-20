// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {InspectorObject} from "src/inspector/libraries/InspectorObjectConstant.sol";

contract Inspector {

    uint256[] private inspectors;
    function registerInspector(InspectorObject.InspectorDTO memory inspectorDTO) external pure returns(uint256 inspectorId_) {
        return 1;
    }
    function convertToLowerCase(string memory input) external pure returns (string memory) {
        return InspectorObject.convertToLowerCase(input);
    }

    function getAllInspectors() external view returns(uint256[] memory) {
        return inspectors;
    }
}
