pragma solidity ^0.8.13;

import "./ownable.sol";

contract ZombieFactory is Ownable{
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie (string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna (string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}

/**

1. Zombie 구조체가 2개의 속성을 더 가지도록 수정하게:

    a. winCount, uint16 타입

    b. lossCount, 역시 uint16 타입

참고: 기억하게, 구조체 안에서 uint들을 압축(pack)할 수 있으니, 
우리가 다룰 수 있는 가장 작은 uint 타입을 사용하는 것이 좋을 것이네. uint8은 너무 작을 것이네. 2^8 = 256이기 때문이지 - 
만약 우리 좀비가 하루에 한 번씩 공격한다면, 일 년 안에 데이터 크기가 넘쳐버릴 수 있을 것이네. 하지만 2^16은 65536이네 - 
그러니 한 사용자가 매일 179년 동안 이기거나 지지 않는다면, 이걸로 안전할 것이네.

2. 이제 우리는 Zombie 구조체에 새로운 속성들을 가지게 되었으니, _createZombie()의 함수 정의 부분을 수정해야 할 필요가 있네.

3. 각각의 새로운 좀비가 0승 0패를 가지고 생성될 수 있도록 좀비 생성의 정의 부분을 변경하게.

 */