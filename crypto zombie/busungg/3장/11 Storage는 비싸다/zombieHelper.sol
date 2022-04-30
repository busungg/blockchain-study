pragma solidity ^0.8.13;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
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
    return result;
  }
}

/*
getZombiesByOwner 함수에서, 
우리는 특정한 사용자가 소유한 모든 좀비를 uint[] 배열로 반환하기를 원하네.

1. result라는 이름의 uint[] memory 변수를 선언하게.

2. 해당 변수에 uint 배열을 대입하게. 
배열의 길이는 이 _owner가 소유한 좀비의 개수여야 하고, 
이는 우리의 mapping인 ownerZombieCount[_owner]를 통해서 찾을 수 있네.

3. 함수의 끝에서 result를 반환하게. 
지금 당장은 빈 배열이지만, 다음 챕터에서 이를 채울 것이네.
 */