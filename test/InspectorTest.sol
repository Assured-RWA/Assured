// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {Inspector} from "src/inspector/Inspector.sol";
import { InspectorObject } from "src/inspector/libraries/InspectorObjectConstant.sol";

contract InspectorTest is Test {
    Inspector private inspector = new Inspector();
    function testConvertStringsToLowerCase() external view {
        console.log("checking the result on the console");
        string memory result = inspector.convertToLowerCase("Oladele");
        assertEq(result, "oladele");
    }

    function testRegisterInspector() external view {
        address user = address(0xa);
        bytes memory name = bytes("Dleex");
        bytes[] memory documents = [bytes(), bytes(), bytes()];
        bytes memory location = bytes("Nigeria");

        InspectorObject.InspectorDTO memory inspectorDTO;
        inspectorDTO.documents = documents;
        inspectorDTO.location = location;
        inspectorDTO.name = name;
        inspectorDTO.user = user;

        inspector.registerInspector(inspectorDTO);
    }


}
