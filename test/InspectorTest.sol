// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {Inspector} from "src/inspector/Inspector.sol";
import {InspectorObject} from "src/inspector/libraries/InspectorObjectConstant.sol";

contract InspectorTest is Test {
    Inspector private inspector = new Inspector();

    function testConvertStringsToLowerCase() external pure {
        console.log("checking the result on the console");
    }

    function testRegisterInspector() external {
        InspectorObject.InspectorDTO memory inspectorDTO = createInspector();

        uint256 inspectorId = inspector.registerInspector(inspectorDTO);
        assertEq(inspectorId, 1);
    }

    function testRegisterMoreThanOneInspector() external {
        InspectorObject.InspectorDTO memory inspectorDTO = createInspector();

        InspectorObject.InspectorDTO memory secondInspectorDTO = createInspector();
        inspectorDTO.name = "Samuel";
        inspectorDTO.user = address(0xb);

        inspector.registerInspector(inspectorDTO);
        uint256 inspectorId = inspector.registerInspector(secondInspectorDTO);

        assertEq(inspectorId, 2);
        uint256 inspectors_ = inspector.inspectorCount();
        assertEq(2, inspectors_);
    }

    function testThatAlreadyExistingAddressCannotRegisterAgain() external {
        InspectorObject.InspectorDTO memory inspectorDTO = createInspector();
        InspectorObject.InspectorDTO memory secondInspectorDTO = createInspector();

        inspector.registerInspector(inspectorDTO);
        vm.expectRevert(abi.encodeWithSignature("DuplicateAddressError(address)", secondInspectorDTO.user));
        inspector.registerInspector(secondInspectorDTO);
    }

    function testThatAlreadyExistingNameCannotRegisterAgain() external {
        InspectorObject.InspectorDTO memory inspectorDTO = createInspector();
        InspectorObject.InspectorDTO memory secondInspectorDTO = createInspector();
        secondInspectorDTO.user = address(0xee);

        inspector.registerInspector(inspectorDTO);
        vm.expectRevert(abi.encodeWithSignature("DuplicateUsernameError(bytes)", bytes(inspectorDTO.name)));
        inspector.registerInspector(secondInspectorDTO);
    }

    // function testThatAllInspectorRegistrationFieldDTOField

    function createInspector() private pure returns (InspectorObject.InspectorDTO memory) {
        address user = address(0xa);
        // bytes memory name = bytes("Whitewizardd");
        bytes[3] memory documents;
        documents[0] = bytes("1");
        documents[1] = bytes("2");
        documents[2] = bytes("3");
        bytes memory location = bytes("Nigeria");

        InspectorObject.InspectorDTO memory inspectorDTO;
        inspectorDTO.documents = documents;
        inspectorDTO.location = location;
        inspectorDTO.name = "WhietWizardd";
        inspectorDTO.user = user;
        inspectorDTO.continent = InspectorObject.Continent.AFRICA;
        inspectorDTO.specialization = InspectorObject.InspectorSpecialization.VEHICLE;

        return inspectorDTO;
    }
}
