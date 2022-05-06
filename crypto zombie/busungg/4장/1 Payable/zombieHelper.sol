pragma solidity ^0.8.13;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
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
이제 payable 함수를 우리의 좀비 게임에 만들어보세.

우리 게임에 좀비의 레벨업을 위해 사용자들이 ETH를 지불할 수 있는 기능이 있다고 가정해보지. 
ETH는 자네가 소유한 컨트랙트에 저장될 것이네 - 이는 자네의 게임을 통해 자네가 돈을 벌 수 있는 간단한 예시이네!

1. uint 타입의 levelUpFee 변수를 정의하고, 여기에 0.001 ether를 대입하게.

2. levelUp이라는 함수를 생성하게. 이 함수는 _zombieId라는 uint 타입의 매개변수 
하나를 받을 것이네. 함수는 external이면서 payable이어야 하네.

3. 이 함수는 먼저 msg.value가 levelUpFee와 같은지 require로 확인해야 하네.

4. 그리고서 좀비의 level을 증가시켜야 하네: zombies[_zombieId].level++.
 */