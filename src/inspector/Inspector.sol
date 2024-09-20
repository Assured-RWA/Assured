// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {InspectorObject} from "src/inspector/libraries/InspectorObjectConstant.sol";

contract Inspector {
    function convertToLowerCase(string memory input) external pure returns (string memory) {
        return InspectorObject.convertToLowerCase(input);
    }
}
