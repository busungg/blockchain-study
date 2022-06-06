pragma solidity ^0.8.13;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
    function balanceOf(address _owner) public view returns (uint256 _balance) {
        // 1. 여기서 `_owner`가 가진 좀비의 수를 반환하게.
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        // 2. 여기서 `_tokenId`의 소유자를 반환하게.
        return zombieToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerZombieCount[_to]++;
        ownerZombieCount[_from]--;
        zombieToOwner[_tokenId] = _to;

        Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {

    }

    function takeOwnership(uint256 _tokenId) public {

    }
}

/**
_transfer에 대한 로직을 정의해보도록 하지.

1. _transfer라는 이름으로 함수를 정의하게. address _from, address _to, 
그리고 uint256 _tokenId 세 개의 인수를 받고, private 함수이어야 하네.

2. 소유자가 바뀌면 함께 바뀔 2개의 매핑을 쓸 것이네: 
ownerZombieCount(한 소유자가 얼마나 많은 좀비를 가지고 있는지 기록)와 
zombieToOwner(어떤 좀비를 누가 가지고 있는지 기록)이네.

3. 이 함수에서 처음 해야 할 일은 바로 좀비를 받는 사람(address _to)의 
ownerZombieCount를 증가시키는 것이네. 증가시킬 때 ++를 사용하도록 하게.

4.다음으로, 좀비를 보내는 사람(address _from)의 ownerZombieCount를
 감소시켜야 하네. 감소시킬 때 --를 쓰도록 하게.

5. 마지막으로, 이 _tokenId에 해당하는 zombieToOwner 매핑 값이 
_to를 가리키도록 변경하게.

6. ERC721 스펙에는 Transfer 이벤트가 포함되어 있네. 
이 함수의 마지막 줄에서 적절한 정보와 함께 Transfer를 실행해야 하네 - 
erc721.sol을 보고 어떤 인수들이 필요한지 확인한 후 여기에 그걸 구현하게.
 */

/**
1. 우리는 토큰/좀비의 소유자만 해당 토큰/좀비를 전송할 수 있도록 하고 싶네.
   자네, 어떻게 그 소유자만 이 함수에 접근할 수 있도록 제한하는지 기억하고 있나?

2. 그래, 바로 그거지. 우리는 이미 이렇게 만들어주는 제어자를 가지고 있네. 
그러니 이 함수에 onlyOwnerOf 제어자를 추가하게.

3. 이제 함수의 내용은 진짜로 딱 한 줄이면 되네... 
그저 _transfer를 호출하기만 하면 되지. 
address _from 인수에 msg.sender를 전달하는 것을 잊지 말게.

*/