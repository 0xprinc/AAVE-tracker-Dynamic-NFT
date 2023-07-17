pragma solidity 0.8.19;


import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
contract C is Test{

    function testone() public {
        vm.prank(0x5D4046683516826f2e83a92bF53E1982904D9cd7);
        console.log(msg.sender);
    }
}