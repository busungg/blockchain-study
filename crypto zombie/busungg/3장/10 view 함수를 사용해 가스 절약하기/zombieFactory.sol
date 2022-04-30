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
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie (string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime))) - 1;
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
우리 DApp에 재사용 대기 시간을 추가하고, 
좀비들이 공격하거나 먹이를 먹은 후 1일이 지나야만 다시 공격할 수 있도록 할 것이네.

1. cooldownTime이라는 uint 변수를 선언하고, 
여기에 1 days를 대입하게.(문법적으로 이상하게 보여도 넘어가게. 
자네가 "1 day"를 대입한다면, 컴파일이 되지 않을 것일세!)

2. 우리가 이전 챕터에서 우리의 Zombie 구조체에 level과 readyTime을 추가했으니, 
우린 Zombie 구조체를 생성할 때 함수의 인수 개수가 정확히 맞도록 
_createZombie() 함수를 업데이트해야 하네.

3. 코드의 zombies.push 줄에 2개의 인수를 더 
사용하도록 업데이트하게: 1(level에 사용), 
uint32(now + cooldownTime)(readyTime에 사용).

참고: now가 기본적으로 uint256을 반환하기 때문에, 
uint32(...) 부분이 필수적이네. 
이렇게 함으로써 해당 데이터를 uint32로 명시적으로 변환하는 것이지.

now + cooldownTime은 현재 유닉스 타임스탬프(초 단위)에 
1일을 초 단위로 바꾼 것의 합과 같을 것이네. 
바꿔 말해 지금부터 하루 뒤의 유닉스 타임스탬프 값과 같은 것이지. 
이후에 우리는 좀비를 다시 사용하기 위해 충분한 시간이 지났는지 확인할 수 있도록 
좀비의 readyTime이 now보다 큰지 비교할 것이네.

다음 챕터에서는 readyTime에 기반하여 행동을 제한하도록 하는 기능들을 구현할 것이네.

 */