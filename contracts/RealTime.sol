
pragma solidity ^0.4.11;
import "./FlexCoin.sol";

contract RealTime {




  struct RealTimeNode {
      address owner;
      uint upPrice;
      uint downPrice;
      uint upAvailableFlex;
      uint downAvailableFlex;
      int deviation;
  }

  uint public wholesalePrice = 470;
  uint public numHouses;

  mapping(uint => RealTimeNode) houses;





  function newRealTimeNode(address _owner) payable public {
      uint houseID = numHouses++;
      RealTimeNode h = houses[houseID];
      h.owner = _owner;
      h.deviation = 0;
      h.upPrice = 0;
      h.downPrice = 0;
      h.upAvailableFlex = 0;
      h.downAvailableFlex = 0;
  }


  function setRealTimeNodePrice(uint _houseID, uint _upPrice, uint _downPrice) public {



          RealTimeNode h = houses[_houseID];
          h.upPrice = _upPrice;
          h.downPrice = _downPrice;

  }


  function setRealTimeNodeBattery(uint _houseID, uint _upAvailableFlex, uint _downAvailableFlex, int _deviation) public {


      RealTimeNode h = houses[_houseID];
      h.upAvailableFlex = _upAvailableFlex;
      h.downAvailableFlex = _downAvailableFlex;
      h.deviation = _deviation;
  }


  function getRealTimeNode(uint _houseID) public constant returns (address, uint, uint, uint, uint, int) {
      return (houses[_houseID].owner, houses[_houseID].upPrice, houses[_houseID].downPrice, houses[_houseID].upAvailableFlex, houses[_houseID].downAvailableFlex, houses[_houseID].deviation);
  }


  function checkSortAndMatching(uint flexFlag, uint[] batteryList1, uint[] batteryList2, uint marketPrice, uint transactedAmount) constant public returns(uint success){





      uint i = 0;
      if (flexFlag == 0){
          for (i = 0; i < (batteryList1.length - 1); i++){
              if((batteryList2[i] > batteryList2[i + 1]) || (batteryList2[i] != houses[batteryList1[i]].upPrice)) {
                  return 0;
              }
          }
      }
      if (flexFlag == 1){
          for (i = 0; i < (batteryList1.length - 1); i++){
              if((batteryList2[i] < batteryList2[i + 1]) || (batteryList2[i] != houses[batteryList1[i]].downPrice)) {
                  return 0;
              }
          }
      }
      if (flexFlag < 0 || flexFlag > 1){
          return 0;
      }






      uint demand = 0;
      uint supply = 0;
      uint reqBattery = 0;
      uint sum_battery = 0;
      for(i = 0; i < numHouses; i++){
          if (houses[i].deviation < 0){
              demand = uint(-houses[i].deviation) + demand;
          }
          if (houses[i].deviation > 0){
              supply = uint(houses[i].deviation) + supply;
          }
      }

      if(demand < supply && (flexFlag != 0 || transactedAmount != supply)) { return 0; }
      if(demand > supply && (flexFlag != 1 || transactedAmount != demand)) { return 0; }




      i = 0;
      if (demand < supply){

          reqBattery = transactedAmount - demand;
          while (sum_battery < reqBattery){
              sum_battery = houses[batteryList1[i]].upAvailableFlex + sum_battery;
              i++;
          }
          if (marketPrice != batteryList2[i - 1]) { return 0; }
      }
      else {
          reqBattery = transactedAmount - supply;
          while (sum_battery < reqBattery){
              sum_battery = houses[batteryList1[i]].downAvailableFlex + sum_battery;
              i++;
          }
          if (marketPrice != batteryList2[i - 1]) { return 0; }
      }
      return 1;
  }


  function checkAndTransactList(uint flexFlag, uint[] batteryList1, uint[] batteryList2, uint[] transactions1, uint[] transactions2, uint[] transactions3, uint marketPrice, address contractAddress) public returns(bool success){
      uint transactedAmount = 0;
      uint i = 0;
      FlexCoin f = FlexCoin(contractAddress);
      for (i; i < transactions1.length; i++) {
          transactedAmount = transactedAmount + transactions3[i];
      }

      if (checkSortAndMatching(flexFlag, batteryList1, batteryList2, marketPrice, transactedAmount) == 1) {
          for (i = 0; i < transactions1.length; i++){
              f.transferHouse(houses[transactions1[i]].owner, houses[transactions2[i]].owner, transactions3[i] * marketPrice);
          }
          return true;
      }
      else {
          return false;
      }
  }

}
