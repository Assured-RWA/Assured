// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PremiumCalculator} from "../src/pemiumCalculator.sol";
import {CentralStorage} from "../src/CentralStorage.sol";
import {Inspector} from "../src/Inspector.sol";
import {Insurance} from "../src/Insurance.sol";
import {Dao} from "../src/Dao.sol";

contract Premium is Test {
    PremiumCalculator public premiumCalculator;
    CentralStorage public centralStorage;
    Inspector public inspector;
    Insurance public insurance;
    Dao public dao;

    address expectedOwner = address(this);
    address clientA = address(0xa);
    address inspector1 = address(0xF);
    address vehicleInspector = address(0xAF);

    function setUp() public {
        vm.prank(expectedOwner);
        premiumCalculator = new PremiumCalculator();
        dao = new Dao();
        // address daoAddress = address(dao);
        centralStorage = new CentralStorage(clientA);
        address centralStorageAddress = address(centralStorage);
        inspector = new Inspector(centralStorageAddress);
        insurance = new Insurance(centralStorageAddress);
    }

    function test_makeInspector() public {
        vm.prank(clientA);
        // centralStorage.onlyDao();
        // inspector.onlyDao();
        inspector.registerInspector(inspector1, 1);
        vm.prank(clientA);
        inspector.approveInspector(inspector1);
        inspector.suspendInspector(inspector1);
        inspector.returnInspectorStatus(inspector1);
    }

    // function test_bookPropertyInspection(uint) public {
    //     vm.deal(clientA, 1000 wei); // Fund the caller with 1 ether (or sufficient amount)
    //     vm.prank(clientA); // Set msg.sender for the next transaction
    //     address contractAddress = address(premiumCalculator);
    //     premiumCalculator.bookPropertyInspection{value: 100}("Narayi");
    //     assertEq(premiumCalculator.returnPropertyOwner(1), clientA);
    //     uint256 balance = address(contractAddress).balance;
    //     assertEq(balance, 100 wei);
    // }`

    // function test_generatePropertyPremium(uint) public {
    //     vm.deal(clientA, 1000 wei); // Fund the caller with 1 ether (or sufficient amount)
    //     vm.prank(clientA); // Set msg.sender for the next transaction
    //     address contractAddress = address(premiumCalculator);
    //     premiumCalculator.bookPropertyInspection{value: 100}("Narayi");
    //     vm.prank(expectedOwner);
    //     premiumCalculator.makeInspector(inspector1, 1);
    //     bool s = premiumCalculator.returnInspectorStatus(inspector1);

    //     assertEq(s, true);
    //     vm.prank(inspector1);
    //     premiumCalculator.inspectAHouse(1);
    //     vm.prank(inspector1);
    //     premiumCalculator.submitPropertyInspectionResultAndGenerate(
    //         1,
    //         80,
    //         3,
    //         150,
    //         1,
    //         5000
    //     );

    //     premiumCalculator.returnPropertyPremium(1);

    //     uint256 contractBalance = address(contractAddress).balance;
    //     uint256 inspectorBalance = address(inspector).balance;
    //     assertEq(contractBalance, 25 wei);
    //     assertEq(inspectorBalance, 75 wei);
    // }

    // function test_bookVehicleInspection(uint) public {
    //     vm.deal(clientA, 1000 wei); // Fund the caller with 1 ether (or sufficient amount)
    //     vm.prank(clientA); // Set msg.sender for the next transaction
    //     address contractAddress = address(premiumCalculator);
    //     premiumCalculator.bookVehicleInspection{value: 50}("Narayi");
    //     assertEq(premiumCalculator.returnVehicleOwner(1), clientA);
    //     uint256 balance = address(contractAddress).balance;
    //     assertEq(balance, 50 wei);
    // }
}
