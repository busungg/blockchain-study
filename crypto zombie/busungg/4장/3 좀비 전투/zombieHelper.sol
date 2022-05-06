pragma solidity ^0.8.13;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
  }

  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }
  
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns (uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);

    uint counter = 0;
    for(uint i = 0; i < zombies.length; i++) {
      if(zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }

    return result;
  }
}

/*
1. 우리 컨트랙트에 withdraw 함수를 생성하게. 
이 함수는 위에서 본 GetPaid 예제와 동일해야 하네.

2.이더의 가격은 과거에 비해 10배 이상 뛰었네. 
그러니 지금 이 글을 쓰는 시점에서는 0.001이더가 1달러 정도 되지만, 
만약 이게 다시 10배가 되면 0.001 ETH는 10달러가 될 것이고 
우리의 게임은 더 비싸질 것이네.

3. 그러니 컨트랙트의 소유자로서 우리가 levelUpFee를 설정할 수 있도록 하는 함수를 
만드는 것이 좋겠지.

a. setLevelUpFee라는 이름의, uint _fee를 하나의 인자로 받고 external이며 
onlyOwner 제어자를 사용하는 함수를 생성하게.

b. 이 함수는 levelUpFee를 _fee로 설정해야 하네.
 */