// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AssuredLibrary.sol";

contract Inspector {
    using AssuredLibrary for AssuredLibrary.Inspectors;

    address daoAddress;
    uint inspectorsId;

    mapping(address => AssuredLibrary.Inspectors) inspectors;

    constructor(address _daoAddress) {
        daoAddress = _daoAddress;
    }

    modifier onlyDao() {
        require(msg.sender == daoAddress, "Only Owner can Perform this Action");
        _;
    }

    // More logic required for the inspector registration can be added in the function below
    function registerInspector(
        address _inspector,
        uint8 _assetType
    ) public returns (bool) {
        AssuredLibrary.Inspectors storage inspector = inspectors[_inspector];
        inspector.assetType = _assetType;
        return true;
    }

    function approveInspector(
        address _inspector
    ) public onlyDao returns (bool, uint) {
        AssuredLibrary.Inspectors storage inspector = inspectors[_inspector];
        inspectorsId++;
        inspector.inspectorId = inspectorsId;
        inspector.valid = true;
        return (true, inspectorsId);
    }

    function deleteInspector(address _inspector) public onlyDao {
        delete inspectors[_inspector];
    }

    function returnInspectorStatus(
        address _inspector
    ) public view returns (bool) {
        AssuredLibrary.Inspectors storage inspector = inspectors[_inspector];

        return inspector.valid;
    }
}
