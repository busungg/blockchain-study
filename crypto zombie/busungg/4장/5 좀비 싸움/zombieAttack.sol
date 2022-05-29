pragma solidity ^0.8.13;

import "./zombieHelper.sol";

contract ZombieBattle is ZombieHelper {
    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint){
        randNonce++;
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    }

    function attack(uint _zombieId, uint _targetId) external {
        
    }
}

/**
1. 컨트랙트에 attackVictoryProbability라는 이름의 uint 변수를 추가하고, 여기에 70을 대입하게.

2. attack이라는 이름의 함수를 생성하게. 이 함수는 두 개의 매개변수를 받을 것이네: _zombieId(uint)와 _targetId(uint)이네. 이 함수는 external이어야 하네.
 */