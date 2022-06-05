pragma solidity ^0.8.13;

import "./zombieHelper.sol";

contract ZombieBattle is ZombieHelper {
    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint){
        randNonce++;
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    }

    function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);

        if(rand <= attackVictoryProbability) {
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount++;
            enemyZombie.winCount++;
        }

        _triggerCooldown(myZombie);
    }
}

/**
1. 함수를 호출하는 사람이 _zombieId를 소유하고 있는지 확인하기 위해 attack 함수에 ownerOf 제어자를 추가하게.

2. 우리 함수에서 처음으로 해야 할 것은 두 좀비의 storage 포인터를 얻어서 그들과 상호작용 하기 쉽도록 하는 것이네.

  a. Zombie storage를 myZombie라는 이름으로 선언하고, 여기에 zombies[_zombieId]를 대입하게.

  b. Zombie storage를 enemyZombie라는 이름으로 선언하고, 여기에 zombies[_targetId]를 대입하게.

3.우린 전투의 결과를 결정하기 위해 0과 99 사이의 난수를 사용할 것이네. 그러니 uint를 rand라는 이름으로 선언하고, 여기에 randMod 함수에 100을 인수로 사용한 값을 대입하게.
 */

 /**
1. rand가 attackVictoryProbability와 같거나 더 작은지 확인하는 if 문장을 만들게.

2. 만약 이 조건이 참이라면, 우리 좀비가 이기게 되네! 그렇다면:

    a. myZombie의 winCount를 증가시키게.

    b. myZombie의 level을 증가시키게. (레벨업이다!!!!!!!)

    c. enemyZombie의 lossCount를 증가시키게. (이 패배자!!!!!!! 😫 😫 😫)

    d. feedAndMultiply 함수를 실행하게. 실행을 위한 문법을 보려면 zombiefeeding.sol을 확인하게. 3번째 인수(_species)로는 "zombie"라는 문자열을 전달하게
    (이건 지금 이 순간에는 실제로 아무 것도 하지 않지만, 이후에 우리가 원한다면 좀비 기반의 좀비를 만들어내는 부가적인 기능을 추가할 수도 있을 것이네).
  */

/**
else 문장을 추가하게. 만약 우리의 좀비가 진다면:

a. myZombie의 lossCount를 증가시키게.

b. enemyZombie의 winCount를 증가시키게.

else 문장의 밖에서, myZombie에 대해 _triggerCooldown 함수를 실행하게. 이러한 방법으로 해당 좀비는 하루에 한 번만 공격할 수 있네.

 */