contract Aave{
    function getPrice(address a) public view returns(uint){} 
}

contract Caller{
    address aaveOracle;
    address token;
    Aave public a = Aave(aaveOracle);

    function get() public view returns(uint){
        return a.getPrice(token);
    }
}
