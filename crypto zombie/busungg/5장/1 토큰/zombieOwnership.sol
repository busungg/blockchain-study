pragma solidity ^0.8.13;

import "./zombieattack.sol";

contract ZombieOwnership is ZombieAttack {
    
}

/**
우리는 다음 챕터에서 ERC721을 구현하기 시작할 것이네. 그전에 먼저, 
이번 레슨을 위한 파일 구조를 만들어 보세.

우리는 모든 ERC721 로직을 ZombieOwnership이라는 컨트랙트에 저장할 것이네.

1. 파일의 최상단에 pragma 버전을 선언하게(문법은 이전 레슨의 파일에서 참고하게).

2. 이 파일은 zombieattack.sol을 import 해야 하네.

3. ZombieOwnership이라는 새로운 컨트랙트를 선언하고, 
ZombieAttack을 상속하게. 컨트랙트의 내용은 지금 당장은 비워두게.
 */