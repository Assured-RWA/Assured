// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AssuredLibrary.sol";
import "./CentralStorage.sol";

contract Inspector {
    using AssuredLibrary for AssuredLibrary.Inspectors;
    CentralStorage centralStorage;

    constructor(address _centralStorage) {
        centralStorage = CentralStorage(_centralStorage);
    }

    // More logic required for the inspector registration can be added in the function below
    function registerInspector(
        address _inspector,
        uint8 _assetType
    ) public returns (bool) {
        // Fetch the inspector from the central storage contract
        AssuredLibrary.Inspectors memory inspector = centralStorage
            .getInspector(_inspector);

        // Update the inspector's asset type
        inspector.assetType = _assetType;

        // Save the updated inspector back to the central storage
        centralStorage.setInspector(_inspector, inspector);

        return true;
    }

    function approveInspector(address _inspector) public returns (bool, uint) {
        AssuredLibrary.Inspectors memory inspector = centralStorage
            .getInspector(_inspector);

        centralStorage.incrementInspectorId();
        inspector.inspectorId = centralStorage.returnInspectorsId();
        inspector.valid = true;

        // Save the updated inspector back to the central storage
        centralStorage.setInspector(_inspector, inspector);
        return (true, centralStorage.returnInspectorsId());
    }

    function suspendInspector(address _inspector) public returns (bool, uint) {
        AssuredLibrary.Inspectors memory inspector = centralStorage
            .getInspector(_inspector);

        centralStorage.incrementInspectorId();
        inspector.inspectorId = centralStorage.returnInspectorsId();
        inspector.valid = false;

        // Save the updated inspector back to the central storage
        centralStorage.setInspector(_inspector, inspector);
        return (true, centralStorage.returnInspectorsId());
    }

    function deleteInspector(address _inspector) public {
        centralStorage.deleteInspector(_inspector);
    }

    function returnInspectorStatus(
        address _inspector
    ) public view returns (bool) {
        AssuredLibrary.Inspectors memory inspector = centralStorage
            .getInspector(_inspector);

        return inspector.valid;
    }
}
