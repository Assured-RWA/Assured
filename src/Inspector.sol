// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AssuredLibrary.sol";

contract Inspector {
    using AssuredLibrary for AssuredLibrary.Inspectors;

    mapping(address => AssuredLibrary.Inspectors) inspectors;

    function registerInspector(
        address _inspector,
        uint8 _assetType
    ) public returns (bool) {
        AssuredLibrary.Inspectors storage inspector = inspectors[_inspector];
        inspector.assetType = _assetType;
        return true;
    }

    function approveInspector(address _inspector) public returns (bool) {
        AssuredLibrary.Inspectors storage inspector = inspectors[_inspector];
        inspector.valid = true;
        return true;
    }
}
