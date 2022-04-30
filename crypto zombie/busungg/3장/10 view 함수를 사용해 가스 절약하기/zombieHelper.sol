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

  }
}

/*
우리는 사용자의 전체 좀비 군대를 반환하는 함수를 구현할 것이네. 
우리가 만약 사용자들의 프로필 페이지에 그들의 전체 군대를 표시하고 싶다면, 나중에 이 함수를 web3.js에서 호출하면 된다네.

이 함수의 내용은 조금 복잡해서, 구현하는 데에 챕터 몇 개를 써야 할 것이네.

1. getZombiesByOwner라는 이름의 함수를 만들게. 이 함수는 _owner라는 이름의 address를 하나의 인수로 받을 것이네.

2. 이걸 external view 함수로 만들게. 우리는 이 함수를 web3.js에서 가스를 쓸 필요 없이 호출할 수 있을 것이네.

3. 이 함수는 uint[]를 반환해야 하네(uint의 배열).

지금은 함수의 내용을 비워두게. 다음 챕터에서 채워나갈 것이네.
 */