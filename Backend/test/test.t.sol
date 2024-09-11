// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PremiumCalculator} from "../src/pemiumCalculator.sol";

contract Premium is Test {
    PremiumCalculator public premiumCalculator;

    address expectedOwner = address(this);
    address clientA = address(0xa);
    address inspector = address(0xF);

    function setUp() public {
        vm.prank(expectedOwner);
        premiumCalculator = new PremiumCalculator();
    }

    function test_bookInspection(uint) public {
        vm.deal(clientA, 1000 wei); // Fund the caller with 1 ether (or sufficient amount)
        vm.prank(clientA); // Set msg.sender for the next transaction
        address contractAddress = address(premiumCalculator);
        premiumCalculator.bookInspection{value: 100}(1);
        assertEq(premiumCalculator.assetOwner(1), clientA);
        uint256 balance = address(contractAddress).balance;
        assertEq(balance, 100 wei);
    }

    function test_generatePremium(uint) public {
        vm.deal(clientA, 1000 wei); // Fund the caller with 1 ether (or sufficient amount)
        vm.prank(clientA); // Set msg.sender for the next transaction
        address contractAddress = address(premiumCalculator);
        premiumCalculator.bookInspection{value: 100}(1);
        vm.prank(expectedOwner);
        premiumCalculator.makeInspector(inspector, 1);
        bool s = premiumCalculator.returnInspectorStatus(inspector);

        assertEq(s, true);
        vm.prank(inspector);
        premiumCalculator.inspectAHouse(1);
        vm.prank(inspector);
        premiumCalculator.submitPropertyInspectionResultAndGenerate(
            1,
            80,
            3,
            150,
            1,
            5000
        );

        premiumCalculator.returnPremium(1);

        uint256 contractBalance = address(contractAddress).balance;
        uint256 inspectorBalance = address(inspector).balance;
        assertEq(contractBalance, 25 wei);
        assertEq(inspectorBalance, 75 wei);
    }
}
