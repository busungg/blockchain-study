pragma solidity ^0.8.13;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
    mapping (uint => address) zombieApprovals;

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

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        zombieApprovals[_tokenId] = _to;
        Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(zombieApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }
}

/**
1. 먼저, zombieApprovals 매핑을 정의해보도록 하지. 
이것은 uint를 address로 연결하여야 하네.

2. 이런 방식으로, 누군가 _tokenId로 takeOwnership을 호출하면, 
이 매핑을 써서 누가 그 토큰을 가지도록 승인받았는지 확인할 수 있네.

3. approve 함수에서, 우리는 오직 그 토큰의 소유자만 다른 사람에게 토큰을 줄 수 있는 
승인을 할 수 있도록 하고 싶네. 그러니 approve에 onlyOwnerOf 
제어자를 추가해야 할 것이네.

3. 함수의 내용에서는 zombieApprovals의 _tokenId 요소를 
_to 주소와 같도록 만들게.

4.마지막으로, ERC721 스펙에 Approval 이벤트가 있네. 
그러니 우리는 이 함수의 마지막에서 이 이벤트를 호출해야 하네. 
erc721.sol에서 인수를 확인하고, msg.sender를 _owner에 쓰도록 하게.
 */

/**
1. 먼저, require 문장을 써서 zombieApprovals의 
_tokenId 요소가 msg.sender와 같은지 확인해야 하네.

 이런 방식으로 만약 msg.sender가 이 토큰을 받도록 승인되지 않았다면, 
 에러를 만들어낼 것이네.

2. _transfer를 호출하기 위해, 우리는 그 토큰을 소유한 사람의 주소를 
알 필요가 있네(함수에서 _from을 인수로 요구하기 떄문이지). 
다행히 우리의 ownerOf 함수를 써서 이를 찾아낼 수 있네.

그러니 address 변수를 owner라는 이름으로 선언하고, 
여기에 ownerOf(_tokenId)를 대입하게.

3. 마지막으로, _transfer를 필요한 모든 정보와 
함께 호출하게(여기서는 msg.sender를 _to에 사용하면 되네. 
이 함수를 호출하는 사람이 토큰을 받을 사람이기 떄문이지).

참고: 2번째와 3번째 단계를 한 줄의 코드로 만들 수 있지만, 나누는 것이 조금 더 읽기 좋게 만드네. 개인적인 선호인 것이지.
 */