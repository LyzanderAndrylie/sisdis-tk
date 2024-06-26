
import "./FlexCoin.sol";

pragma solidity ^0.4.11;
contract DurationSecure {

    struct Node {
        address owner;
        uint nodeID;
        uint numDemandHours;
        uint[] demandPrices;
        uint[] supplyHours;
    }

    uint public numNodes;
    mapping(uint => Node) public nodes;

    function setNode(uint _numDemandHours, uint[] _demandPrices, uint[] _supplyHours) public {
        Node n = nodes[numNodes];
        n.owner = msg.sender;
        n.nodeID = numNodes;
        n.numDemandHours = _numDemandHours;
        n.demandPrices = _demandPrices;
        n.supplyHours = _supplyHours;
        numNodes = numNodes + 1;
    }


    function getNode(uint _nodeID, uint timeStep, uint nodeFlag) constant public returns(address, uint, uint, uint){
        if (nodeFlag == 0){
            return (nodes[_nodeID].owner, nodes[_nodeID].numDemandHours, nodes[_nodeID].demandPrices[0], nodes[_nodeID].supplyHours[timeStep]);
        }
        else {
            return (nodes[_nodeID].owner, nodes[_nodeID].numDemandHours, nodes[_nodeID].demandPrices[timeStep], nodes[_nodeID].supplyHours[0]);
        }
    }

    function checkAndTransfer(uint[] sortedList, uint[] from, uint[] to, uint timeStep, address contractAddress) public returns(bool success) {

        FlexCoin f = FlexCoin(contractAddress);

        uint i = 0;
        if (sortedList.length > 1) {


            for (i; i < (sortedList.length - 1); i++) {
                if (nodes[sortedList[i]].demandPrices[timeStep] > nodes[sortedList[i + 1]].demandPrices[timeStep]) { return false; }
                if (from[i] != nodes[sortedList[i]].nodeID || nodes[to[i]].supplyHours[timeStep] == 0) { return false; }
                f.transferHouse(nodes[from[i]].owner, nodes[to[i]].owner, nodes[sortedList[sortedList.length - 1]].demandPrices[timeStep]);
            }
        }
        if (from[i] != nodes[sortedList[i]].nodeID || nodes[to[i]].supplyHours[timeStep] == 0) { return false; }
        f.transferHouse(nodes[from[i]].owner, nodes[to[i]].owner, nodes[from[i]].demandPrices[timeStep]);

    }

}
