// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {Inspector} from "src/inspector/Inspector.sol";
import {InspectorObject} from "src/inspector/libraries/InspectorObjectConstant.sol";

contract InspectorTest is Test {
    Inspector private inspector = new Inspector();

    function testConvertStringsToLowerCase() external {
        console.log("checking the result on the console");
        string memory result = inspector.convertToLowerCase("Oladele");
        assertEq(result, "oladele");
    }

    function testRegisterInspector() external {
        InspectorObject.InspectorDTO memory inspectorDTO = createInspector();

        uint256 inspectorId = inspector.registerInspector(inspectorDTO);
        assertEq(inspectorId, 1);
    }

    function testRegisterMoreThanOneInspector() external {
        InspectorObject.InspectorDTO memory inspectorDTO = createInspector();

        InspectorObject.InspectorDTO memory secondInspectorDTO = createInspector();
        inspectorDTO.name = bytes("Samuel");
        inspectorDTO.user = address(0xb);

        inspector.registerInspector(inspectorDTO);
        uint256 inspectorId = inspector.registerInspector(secondInspectorDTO);

        assertEq(inspectorId, 2);
        InspectorObject.Inspector[] memory allInspectors = inspector.getAllInspectors();
        assertEq(2, allInspectors.length);
    }

    function testThatAlreadyExistingAddressCannotRegisterAgain() external {
        InspectorObject.InspectorDTO memory inspectorDTO = createInspector();
        InspectorObject.InspectorDTO memory secondInspectorDTO = createInspector();

        inspector.registerInspector(inspectorDTO);
        vm.expectRevert();
        inspector.registerInspector(secondInspectorDTO);
    }

    function createInspector() private pure returns (InspectorObject.InspectorDTO memory) {
        address user = address(0xa);
        bytes memory name = bytes("Whitewizardd");
        bytes[3] memory documents;
        documents[0] = bytes("1");
        documents[1] = bytes("2");
        documents[2] = bytes("3");
        bytes memory location = bytes("Nigeria");

        InspectorObject.InspectorDTO memory inspectorDTO;
        inspectorDTO.documents = documents;
        inspectorDTO.location = location;
        inspectorDTO.name = name;
        inspectorDTO.user = user;

        return inspectorDTO;
    }
}
