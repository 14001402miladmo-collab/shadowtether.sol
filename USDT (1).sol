// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Trusted USDT (Tether) contract address on Ethereum Mainnet
address constant TRUSTED_USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract USDT {
    IERC20 public constant usdt = IERC20(TRUSTED_USDT);

    constructor() {
    }

    function transfer(address to, uint256 value) external returns (bool) {
        return usdt.transfer(to, value);
    }

    function balanceOf(address account) external view returns (uint256) {
        return usdt.balanceOf(account);
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        return usdt.transferFrom(from, to, value);
    }

    function approve(address spender, uint256 value) external returns (bool) {
        return usdt.approve(spender, value);
    }

    receive() external payable {}
}
