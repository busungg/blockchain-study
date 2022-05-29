pragma solidity ^0.8.13;

import "./zombieHelper.sol";

contract ZombieBattle is ZombieHelper {
    uint randNonce = 0;

    function randMod(uint _modulus) internal returns(uint){
        randNonce++;
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    }
}

/**
공격에서 완전히 안전하지는 않더라도, 전투의 결과를 결정하는 데에 사용할 수 있는 난수 함수를 구현해보세.

1. 컨트랙트에 randNonce라는 이름의 uint 타입 변수를 추가하고, 0을 대입하게.

2. randMod(random-modulus)라는 이름의 함수를 생성하게. 이 함수는 _modulus라는 이름의 uint 타입 변수를 받는 internal 함수일 것이고, uint 타입을 반환(returns)할 것이네.

3. 해당 함수는 먼저 randNonce를 하나 증가시킬 것이네(randNonce++ 문법을 사용하게).

3. 마지막으로, (한 줄의 코드로)now, msg.sender, randNonce의 keccak256 해시 값을 계산하고 uint로 변환해야 하네 - 그리고 그 값 % _modulus를 한 후 return해야 
하네(후, 내용이 아주 장황헀군. 잘 이해가 안 된다면, 위에서 우리가 난수를 만들었던 예시를 보게 - 구조가 매우 유사하네).
 */