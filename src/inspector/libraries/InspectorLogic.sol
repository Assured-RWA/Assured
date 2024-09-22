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
        inspector.name = bytes(inspectorDTO.name);
        inspector.inspectorAddress = inspectorDTO.user;
        inspector.registrationPeriod = block.timestamp;
        inspector.continent = inspectorDTO.continent;
        inspector.inspectorStatus = InspectorObject.InspectorStatus.REVIEW;

        inspectorMapping[inspectorDTO.user] = inspector;
        allInspectors.push(inspector);
        _inspector[allInspectors.length + 1] = inspector;
        return allInspectors.length;
    }

    function checkDuplicateAddress(mapping(address => bool) storage existingAddress, address inspectorAddress)
        internal
        view
        returns (bool result)
    {
        return existingAddress[inspectorAddress];
    }

    function checkDuplicateName(mapping(bytes => bool) storage existingName, string memory name)
        internal
        view
        returns (bool result, bytes memory)
    {
        bytes memory convertedName = convertToLowerCase(name);
        return (result = existingName[convertedName], convertedName);
    }

    function convertToLowerCase(string memory input) private pure returns (bytes memory result) {
        bytes memory stringBytes = bytes(input);
        bytes memory lowerCaseBytes = new bytes(stringBytes.length);
        for (uint256 i = 0; i < stringBytes.length; i++) {
            // Convert to lowercase if character is uppercase
            if (stringBytes[i] >= 0x41 && stringBytes[i] <= 0x5A) {
                lowerCaseBytes[i] = bytes1(uint8(stringBytes[i]) + 32);
            } else {
                lowerCaseBytes[i] = stringBytes[i];
            }
        }
        result = lowerCaseBytes;
    }
}
